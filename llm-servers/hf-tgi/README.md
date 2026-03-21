# Hugging Face Text Generation Inference Deployment

Example deployment of the [Text Generation Inference](https://github.com/huggingface/text-generation-inference) server from Hugging Face for OpenShift.

The server goes in pair with the [text-generation](https://pypi.org/project/text-generation/) library to easily consume the service.

A notebook example using Langchain is available [here](../../examples/notebooks/langchain/Langchain-HFTGI-Prompt-memory.ipynb).

## Basic Installation

The basic installation deploys the [Flan-t5-XL](https://huggingface.co/google/flan-t5-xl) model, using quantization. Although on the smaller side of LLMs, it will still require a GPU to work properly in a fast enough manner. See [Advanced installation](#advanced-installation) for instructions on how to change the model as well as various settings.

### Deployment procedure

1. **Clone** or navigate to [this repository](https://github.com/nerc-project/llm-on-nerc.git).

    To get started, clone the repository using:

    ```sh
    git clone https://github.com/nerc-project/llm-on-nerc.git
    cd llm-on-nerc/llm-servers/hf-tgi/
    ```

2. In the `standalone` folder, you will find the following YAML files:

  -   `01-hf-tgi-pvc.yaml`: Create PVC named `models-cache` with enough space to hold all the models you want to try.

  -   `02-hf-tgi-deployment.yaml`: Create the Deployment using the file.

  -   `03-hf-tgi-service.yaml`: Create the Service using file.

  -   `04-hf-tgi-route.yaml`: If you want to expose the server outside of your OpenShift cluster, create the Route with the file.

You can run this `oc` command: `oc apply -f ./standalone/.` to execute all of the
above described YAML files located in the **standalone** folder at once.

```sh
oc apply -f ./standalone/.

persistentvolumeclaim/models-cache configured
deployment.apps/hf-tgi-deployment created
service/hf-tgi-service created
route.route.openshift.io/hf-tgi-route created
```

Your model is now accessible at the endpoints:

- defined by your Deployment, the "server" container is the main application container. It uses the fetched **google/flan-t5-xl** model file and runs with certain arguments and resource limits along with GPU count of `1` and type `Tesla-V100-PCIE-32GB`.

    **NOTE:** When requesting NERC GPU resources directly from pods and deployments, you must include the `spec.tolerations` and `spec.nodeSelector` for your desired GPU type. Also, the `spec.containers.resources.requests` and `spec.containers.resources.limits` needs to include the `nvidia.com/gpu` specification that indicates the number of GPUs you want in your container.

- defined by your Service, accessible internally on port **3000 for http**. e.g. `http://hf-tgi-service.<your-namespace>.svc.cluster.local:3000/`

- defined by your Route, accessible externally through https, e.g. `https://hf-tgi-route-<your-namespace>.apps.shift.nerc.mghpcc.org`.

Full API documentation (with live testing) is available under the /docs url, e.g. `https://hf-tgi-route-<your-namespace>.apps.shift.nerc.mghpcc.org/docs/`

## Clean Up

To delete all resources if not necessary just run `oc delete -f ./standalone/.` or `oc delete all,pvc -l app=hf-tgi`.

## Usage

You can directly query the model using either the `/generate` or `/generate_stream` routes:

```bash
curl https://hf-tgi-route-<your-namespace>.apps.shift.nerc.mghpcc.org/generate \
    -X POST \
    -d '{"inputs":"What is Deep Learning?","parameters":{"max_new_tokens":20}}' \
    -H 'Content-Type: application/json'
curl https://hf-tgi-route-<your-namespace>.apps.shift.nerc.mghpcc.org/generate_stream \
    -X POST \
    -d '{"inputs":"What is Deep Learning?","parameters":{"max_new_tokens":20}}' \
    -H 'Content-Type: application/json'
```

or from Python:

```bash
pip install text-generation
```

```python
from text_generation import Client

client = Client("https://hf-tgi-route-<your-namespace>.apps.shift.nerc.mghpcc.org")
print(client.generate("What is Deep Learning?", max_new_tokens=20).generated_text)

text = ""
for response in client.generate_stream("What is Deep Learning?", max_new_tokens=20):
    if not response.token.special:
        text += response.token.text
print(text)
```

## Advanced installation

### Parameters

Different environment variables are available in the Deployment so that you can tweak the way the model is deployed:

- `MODEL_ID`: the name of the model hosted on HuggingFace to use, e.g. `google/flan-t5-xl`.

- `MAX_INPUT_LENGTH`: maximum number of tokens that can be sent to the inference endpoint.

- `MAX_TOTAL_TOKENS`: maximum number of tokens (so MAX_INPUT + tokens generated).

- `QUANTIZE`: if you want your model to be quantized. Possible values `bitsandbytes`, `bitsandbytes-nf4` and `bitsandbytes-fp4`.

- `HUGGINGFACE_HUB_CACHE`: where the models are cached. Default value for the Deployment is `/models-cache`, where the PVC you created for this purpose is mounted.

- `HUGGING_FACE_HUB_TOKEN`: if you model requires an authorization to be downloaded (e.g. **Llama2**), use this parameter to enter you Hugging Face API token. The best is to load it from a secret.

**NOTE:** Please refer to the documentation for other parameters you can modify.

## Deploying TGIS with FLAN-T5 Small Model on NERC RHOAI

Alternatively, you can set up the Text Generation Inference Service (TGIS) with the `FLAN-T5 Small` model using single-model serving and a serving runtime, such as the `TGIS Standalone ServingRuntime for KServe`. This approach offers a lightweight and efficient solution for running text generation workloads. Follow the detailed guide [here](https://nerc-project.github.io/nerc-docs/openshift-ai/other-projects/serving-tgis-and-FLAN-T5-Model/) to set up and get started.
