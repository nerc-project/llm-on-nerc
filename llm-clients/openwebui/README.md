# Open WebUI Helm Chart for OpenShift

[Open WebUI](https://docs.openwebui.com/) is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline. It supports various LLM runners like **Ollama** and **OpenAI-compatible APIs**, with **built-in inference engine** for *RAG*, making it a **powerful AI deployment solution**.

## Prerequisites

- OpenShift cluster access with `oc` CLI configured.

- [Helm](https://helm.sh/) installed locally.

- **vLLM** endpoint with Model is running and accessible.

## Steps

1.  **Clone** or navigate to [this repository](https://github.com/nerc-project/llm-on-nerc.git).

    To get started, clone the repository using:

    ```sh
    git clone https://github.com/nerc-project/llm-on-nerc.git
    cd llm-on-nerc/llm-clients/openwebui/charts/openwebui
    ```

2. Prepare `values.yaml` to connect the Open WebUI to the Deployed vLLM Model.

   Edit the `values.yaml` file to specify your running vLLM model and endpoint:

   ```yaml
   vllmEndpoint: http://vllm.example.svc:8000/v1
   vllmModel: granite-3.3-2b-instruct
   vllmToken: ""
   ```

3. Install **Helm chart**

Deploy Open WebUI using Helm with your configuration:

```sh
helm install openwebui ./ -f values.yaml
```

**Output:**

```
NAME: openwebui
LAST DEPLOYED: Tue Dec  2 22:52:06 2025
NAMESPACE: <your-namespace>
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
1. Get the Open WebUI URL by running these commands:
  route_hostname=$(kubectl get --namespace <your-namespace> route openwebui -o jsonpath='{.status.ingress[0].host}')
  echo https://${route_hostname}
```

4. Access Open WebUI and Test vLLM integration.

Ensure the UI is connected to your vLLM endpoint by sending a simple prompt and verifying the response.

## To Remove the Helm Chart

```sh
helm uninstall openwebui
```
