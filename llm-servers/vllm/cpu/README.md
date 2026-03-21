# CPU vLLM Deployment

Example deployment of the [vLLM](https://github.com/vllm-project/vllm) server for OpenShift, specifically built for **CPU**.

This deployment uses a UBI9 image defined in `Containerfile` and accessible at `quay.io/rh-aiservices-bu/vllm-cpu-openai-ubi9` (check for the latest version available).

This image implements the OpenAI API interface for maximum compatibility with other tools. See [here](https://docs.vllm.ai/en/latest/getting_started/quickstart.html#openai-compatible-server) for more information.

A notebook example using Langchain is available [here](../../../examples/notebooks/langchain/Langchain-vLLM-Prompt-memory.ipynb).

## Basic Installation

The default installation deploys the [TinyLlama-1.1B-Chat-v1.0](https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0) model. See [Advanced installation](#advanced-installation) for instructions on how to change the model as well as various settings.

### Deployment procedure

1. **Clone** or navigate to [this repository](https://github.com/nerc-project/llm-on-nerc.git).

    To get started, clone the repository using:

    ```sh
    git clone https://github.com/nerc-project/llm-on-nerc.git
    cd llm-on-nerc/llm-servers/vllm/cpu/
    ```

2. In the `standalone` folder, you will find the following YAML files:

  -   `01-pvc.yaml`: Create PVC named `vllm-models-cache` with enough space to hold all the models you want to try.

  -   `02-deployment.yaml`: Create the Deployment using the file.

  -   `03-service.yaml`: Create the Service using file.

  -   `04-route.yaml`: If you want to expose the server outside of your OpenShift cluster, create the Route with the file.

Then, you can run this `oc` command: `oc apply -f ./standalone/.` to execute all of the
above described YAML files located in the **standalone** folder at once.

```sh
oc apply -f ./standalone/.

persistentvolumeclaim/vllm-models-cache created
deployment.apps/vllm-deployment created
service/vllm-service created
route.route.openshift.io/vllm-route created
```

## Post Installation Tasks

As of April 18, 2024 some of the available models on Hugging Face are now gated - meaning that you will require a [user access token](https://huggingface.co/docs/hub/security-tokens) in order for these to be downloaded at pod startup. Perform these steps to implement this:

- Sign up for an account at [huggingface.co](https://huggingface.co), and login

- Navigate to your user profile, settings, Access Tokens

- Create a new access token, and copy the details

- In OpenShift web console, navigate to the deployment, vllm, environment variables

- Add your token value to the `HUGGING_FACE_HUB_TOKEN` environment variable.

- Restart the deployment to roll out an updated pod.

The API is now accessible at the endpoints:

- defined by your Service, accessible internally on port **8000** using http. E.g. `http://vllm-service.<your-namespace>.svc.cluster.local:8000/`

- defined by your Route, accessible externally through https, e.g. `https://vllm-route-<your-namespace>.apps.shift.nerc.mghpcc.org`

vLLM also includes an OpenAPI web interface that can be access from a browser by adding `docs` to the path, e.g.  `https://vllm-route-<your-namespace>.apps.shift.nerc.mghpcc.org/docs`

## Clean Up

To delete all resources if not necessary just run `oc delete -f ./standalone/.` or `oc delete all,pvc -l app=vllm-cpu`.

## Usage

You can directly query the model using the [OpenAI API protocol](https://platform.openai.com/docs/api-reference/). The server currently hosts one model at a time, and currently implements [list models](https://platform.openai.com/docs/api-reference/models/list), [create chat completion](https://platform.openai.com/docs/api-reference/chat/completions/create), and [create completion](https://platform.openai.com/docs/api-reference/completions/create) endpoints.

Example of calling the `/v1/models` endpoint to list the available models:

```bash
curl https://vllm-route-<your-namespace>.apps.shift.nerc.mghpcc.org/v1/models \
  -H 'accept: application/json'
```

Example of calling the `/v1/completions` endpoint to complete a sentence:

```bash
curl https://vllm-route-<your-namespace>.apps.shift.nerc.mghpcc.org/v1/completions \
      -H "Content-Type: application/json" \
      -d '{
          "model": "TinyLlama/TinyLlama-1.1B-Chat-v1.0",
          "prompt": "San Francisco is a",
          "max_tokens": 7,
          "temperature": 0
      }'
```

Example of calling the `/v1/chat/completions` endpoint demonstrating a conversation:

```bash
curl https://vllm-route-<your-namespace>.apps.shift.nerc.mghpcc.org/v1/chat/completions \
      -H "Content-Type: application/json" \
      -d '{
            "model": "TinyLlama/TinyLlama-1.1B-Chat-v1.0",
            "messages": [
              {"role": "user", "content": "Who won the world series in 2020?"},
              {"role": "assistant", "content": "You are a helpful assistant."}
            ]
          }'
```

or from Python:

```bash
pip install text-generation
```

```python
from openai import OpenAI
# Set OpenAI's API key and API base to use vLLM's API server.
openai_api_key = "EMPTY"
openai_api_base = "https://vllm-route-<your-namespace>.apps.shift.nerc.mghpcc.org/v1"

client = OpenAI(
    api_key=openai_api_key,
    base_url=openai_api_base,
)

chat_response = client.chat.completions.create(
    model="TinyLlama-1.1B-Chat-v1.0",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Tell me a joke."},
    ]
)
print("Chat response:", chat_response)
```

You can also find a notebook example using Langchain to query vLLM in this repo [here](../../../examples/notebooks/langchain/Langchain-vLLM-Prompt-memory.ipynb).

## Advanced installation

### Parameters

All the parameters to start the model are passed as arguments (see L35 in the Deployment file).

The full list of available parameters is available [here](https://docs.vllm.ai/en/latest/models/engine_args.html).
