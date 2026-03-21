# Ollama Deployment

[Ollama](https://ollama.com/) is an open-source platform designed to simplify the deployment and management of large language models (LLMs). It provides a user-friendly interface for running, managing, and interacting with various LLMs without requiring complex configurations.

This repo provides example deployment of the [Ollama](https://github.com/ollama/ollama) server to run on the NERC OpenShift environment.

This deployment uses a `ollama/ollama:latest` image defined in `spec.containers.image` under Deployment YAML file.

## A Standalone Deployment

We can install Ollama as a Standalone Deployment along with [Open WebUI](https://github.com/open-webui/open-webui) by manually running `oc` commands (from the `standalone` folder).

### Deployment Options

There are **Two Deployment Options** to deploy Ollama in standalone mode with the application named as **"ollama"**. In both cases, it automatically deploys the pre-fetched [**Tinyllama model**](https://ollama.com/library/tinyllama:1.1b). The TinyLlama project is an open endeavor to train a compact 1.1B Llama model on 3 trillion tokens.

1. **Clone** or navigate to [this repository](https://github.com/nerc-project/llm-on-nerc.git).

    To get started, clone the repository using:

    ```sh
    git clone https://github.com/nerc-project/llm-on-nerc.git
    cd llm-on-nerc/llm-servers/ollama/
    ```

2. In `standalone/ollama-statefulset-deployment`, it uses **StatefulSet** on the NERC OpenShift to ensure stable, persistent identities for its pods, which is essential for applications that require stable network identities or persistent storage.

    This folder includes:

    -   **01-ollama-statefulset.yaml**: Defines a **StatefulSet** to deploy Ollama with persistent storage, ensuring data is retained across restarts.

    -   **02-ollama-service.yaml**: Exposes the **Ollama StatefulSet** as a **Service** for internal communication within the cluster.

    -   **03-ollama-route.yaml**: Configures a **Route** to expose the Ollama service externally, allowing web access.

    -   **04-open-webui-pvc.yaml**: Defines a **Persistent Volume Claim (PVC)** to store persistent data for **Open WebUI**. Adjust the storage size according to your needs.

    -   **05-open-webui-deployment.yaml**: Deploys the **Open WebUI**, a web-based interface for interacting with Ollama.

    -   **06-open-webui-service.yaml**: Exposes the **Open WebUI** as a **Service**, enabling internal communication.

    -   **07-open-webui-route.yaml**: Configures a **Route** to expose the **Open WebUI** externally for web-based interaction via a web browser interface, typically for managing and interacting with LLMs.

You can run this `oc` command: `oc apply -f ./standalone/ollama-statefulset-deployment/.` to execute all of the above described YAML files located in the **standalone/ollama-statefulset-deployment** folder at once.

```sh
oc apply -f ./standalone/ollama-statefulset-deployment/.

statefulset.apps/ollama created
service/ollama-service created
route.route.openshift.io/ollama-route created
persistentvolumeclaim/open-webui-pvc created
deployment.apps/open-webui-deployment created
service/open-webui-service created
route.route.openshift.io/open-webui-route created
```

To delete all resources if not necessary just run `oc delete -f ./standalone/ollama-statefulset-deployment/.` or `oc delete all,pvc -l app=ollama`.

2. In `standalone/ollama-stateless-deployment` it uses normal deployment with persistent storage.

    This folder includes:

    -   **01-ollama-pvc.yaml**: Defines the **Persistent Volume Claim (PVC)** for storing model data in a stateless deployment.

    -   **02-ollama-deployment.yaml**: Creates a **Deployment** for running the Ollama container with persistent storage.

    -   **03-ollama-service.yaml**: Exposes the **Ollama deployment** as a **Service** to allow communication between the container and other services.

    -   **04-ollama-route.yaml**: Configures a **Route** to expose the Ollama service to external traffic, enabling web access.

    -   **05-open-webui-deployment.yaml**: Deploys the **Open WebUI** with all required PVC, Deployment, Service, Route, etc. resources for interacting with Ollama via a web browser interface, typically for managing and interacting with LLMs.

You can run this `oc` command: `oc apply -f ./standalone/ollama-stateless-deployment/.` to execute all of the above described YAML files located in the **standalone** folder at once.

```sh
oc apply -f ./standalone/ollama-stateless-deployment/.

persistentvolumeclaim/ollama-volume-pvc created
deployment.apps/ollama-deployment created
service/ollama-service created
route.route.openshift.io/ollama-route created
persistentvolumeclaim/open-webui-pvc created
deployment.apps/open-webui-deployment created
service/open-webui-service created
route.route.openshift.io/open-webui-route created
```

To delete all resources if not necessary just run `oc delete -f ./standalone/ollama-stateless-deployment/.` or `oc delete all,pvc -l app=ollama`.

## Usage

The API is now accessible at the endpoints:

-   defined by your Ollama Service, accessible internally on port **11434** using http.

    This is accessible **within the cluster only**, such as from the NERC RHOAI Workbench hosted Jupyter Notebooks or another pod within your project namespace.

    You can use either the service name or the fully qualified internal Hostname for service routing, as shown below:

    -   **Option 1:** Using the service name i.e. `http://ollama-service:11434`

    -   **Option 2:** Using the full internal hostname i.e. `http://ollama-service.<your-namespace>.svc.cluster.local:11434`

-   defined by your Ollama Route, accessible externally through https, e.g. `https://ollama-route-<your-namespace>.apps.shift.nerc.mghpcc.org`.

-   defined by your Open WebUI Route, accessible externally through https, e.g. `https://open-webui-route-<your-namespace>.apps.shift.nerc.mghpcc.org`.

### Access deployed Open WebUI for Ollama

To access the deployed Open WebUI for Ollama, follow these steps:

-   **Find the Route URL:** From the deployed Open WebUI i.e. `open-webui-deployment` with a route, use the route URL to access the web UI. The route typically looks like: `https://open-webui-route-<your-namespace>.apps.shift.nerc.mghpcc.org`.

**NOTE:** Replace `<your-namespace>` with the appropriate namespace where your deployment is run.

-   **Access the Open WebUI:** Open a web browser and enter your email and temporaty password in the displayed login page. After login, you will get access to the Open WebUI for Ollama.

### Useful APIs

Goto [`https://ollama-route-<your-namespace>.apps.shift.nerc.mghpcc.org/api/tags`](https://ollama-route-<your-namespace>.apps.shift.nerc.mghpcc.org/api/tags). The `api/tags` endpoint in the Ollama API is typically used to retrieve or manage tags associated with specific models or versions in the system.

You can directly query the model using either the `/api/generate` endpoint:

```sh
curl http://ollama-service:11434/api/generate \
      -H "Content-Type: application/json" \
      -d '{
        "model": "tinyllama:1.1b",
        "prompt":"Why is the sky blue?"
      }'
```

or from Python:

```sh
pip install ollama
```

```python
import ollama

client = ollama.Client(host='http://ollama-service:11434')

stream = client.chat(
  model='tinyllama:1.1b',
  messages=[{'role': 'user', 'content': 'Why is the sky blue?'}],
  stream=True,
)

for chunk in stream:
  print(chunk['message']['content'], end='', flush=True)
```

## Pull the Models

**NOTE:** You can go to the [Open WebUI](#access-deployed-open-webui-for-ollama) and download any new models as per your need.

If you prefer not to use **the Open WebUI**, you can directly download the model you want by querying either the `/api/pull` endpoint:

```bash
curl http://ollama-service:11434/api/pull \
    -k \
    -H "Content-Type: application/json" \
    -d '{"name": "mistral"}'
```

**Or,** you can also use your terminal to pull and set up any new models on your Ollama instance. Open an interactive bash terminal inside the specified pod to execute commands related to model management. Replace `<pod-name>` with the actual name of the Ollama pod (e.g., `ollama-deployment-5d885557f9-77zzx`):

```sh
oc rsh pod/<pod-name>
```

**NOTE:** Alternatively, you can access the terminal directly from the NERC OpenShift Web Console. In the **Topology View**, click on your application (e.g., `ollama`) or select the application circle if you are in the graphical topology view. In the details panel that opens, go to the **Pods** section under the "Resources" tab, and click the link to view the "Pod details" page. Here, you'll find a "Terminal" tab that provides direct access to an executable terminal connected to the pod.

Once you have access to the pod terminal, you can execute Ollama commands to manage models, run inference, or perform other operations.

Pull LLMs (Large Language Models) like `granite-code:3b`, `mistral:7b` and VLMs (Vision Language Models) like `llama3.2-vision:11b`. Execute the following commands to pull the models:

```sh
ollama pull granite-code:3b
ollama pull mistral:7b
ollama pull llama3.2-vision:11b
```

**NOTE:** You can search and view the available models that can be pulled [here](https://ollama.com/search).

List all the models you've pulled to ensure they're available:

```sh
ollama list

NAME              ID              SIZE      MODIFIED
tinyllama:1.1b    2644915ede35    637 MB    2 minutes ago
...
```

This will ensure that you have successfully pulled the models and they are ready to be used.
