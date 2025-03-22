# llama.cpp

[llama.cpp](https://github.com/ggml-org/llama.cpp) is an open-source software library, primarily written in C++, designed for performing inference on various large language models, including Llama. It is developed in collaboration with the GGML project, a general-purpose tensor library.

The library includes command-line tools as well as a server featuring a simple Web User Interface (UI).

1.  **Clone** or navigate to [this repository](https://github.com/nerc-project/llm-on-nerc.git).

    To get started, clone the repository using:

    ```sh
    git clone https://github.com/nerc-project/llm-on-nerc.git
    cd llm-on-nerc/llm-servers/llama.cpp/
    ```

    In the `standalone` folder, you will find the following YAML files:

    i. `01-llama-cpp-pvc.yaml`: Creates a persistent volume to store the model file. Adjust the storage size according to your needs.

    ii. `02-llama-cpp-deployment.yaml`: Deploys the application.

    iii. `03-llama-cpp-service.yaml`, `04-llama-cpp-route.yaml`: Set up external access to connect to
    the Inference runtime Web UI.

2. Apply the Persistent Volume Claim (PVC) configuration that creates persistent volume claim named "llama-cpp-pvc":

    ```sh
    oc apply -f ./standalone/01-llama-cpp-pvc.yaml

    persistentvolumeclaim/llama-cpp-pvc created
    ```

    This PVC will be used to mount the `/models` directory inside the container for storing the model file.

3. Apply the deployment for the ready container runtime that pulls **Mistral-7B** model from Hugging Face:

    ```sh
    oc apply -f ./standalone/02-llama-cpp-deployment.yaml

    deployment.apps/llama-cpp-deployment created
    ```

    The above YAML file is a Kubernetes deployment configuration for an application named "llama-cpp". It specifies that there should be one replica of the application running. The application consists of two containers: "fetch-model-data" and "llama-cpp".

    -   The "fetch-model-data" container is an init container that fetches a LLM model file i.e. `mistral-7b-instruct-v0.3.Q4_K_M.gguf` from a specified URL if it doesn't already exist in the specified volume named "llama-cpp-pvc" and saves it there. This container does not start the main application.

    -   The "llama-cpp" container is the main application container. It uses the fetched **Mistral-7B** model file and runs with certain arguments and resource limits along with GPU count of `1` and type `Tesla-V100-PCIE-32GB`.

    **NOTE:** When requesting NERC GPU resources directly from pods and deployments, you must include the `spec.tolerations` and `spec.nodeSelector` for your desired GPU type. Also, the `spec.containers.resources.requests` and `spec.containers.resources.limits` needs to include the `nvidia.com/gpu` specification that indicates the number of GPUs you want in your container.

    It listens on port 8080 for HTTP requests. The readiness probe waits 30 seconds before checking if the container is ready, while the liveness probe checks every 10 seconds. Both probes use an HTTP GET request to the root path of the container.

    The deployment also specifies the use of the previously created PVC named "llama-cpp-pvc" to mount the `/models` directory inside the container for storing the model file.

    ## Container image

    **Very Important:** The container image specified here, i.e., `spec.containers.image`, is built using the provided [Containerfile](Containerfile) and pushed to [quay.io](https://quay.io/milstein/llama-runtime-ubi:latest) using [podman](https://podman.io/). This is due to the fact that the current NERC hardware hosting the OpenShift cluster does not support the [IBM Power10 architecture](https://www.ibm.com/products/power-e1080). If you want to use your own custom-built image, you will need to build and use it in a similar manner.

4. Apply the service to expose internal port of the llama.cpp container:

    ```sh
    oc create -f ./standalone/03-llama-cpp-service.yaml

    service/llama-cpp-service created
    ```

    The above YAML file defines a Kubernetes Service named "llama-cpp-service" with the following specifications:

    -   It belongs to your current namespace from where you run the `oc` command and is labeled as "llama-cpp-service".

    -   The service type is "ClusterIP", meaning it is only accessible within the cluster.

    -   It exposes port 8080 (TCP) from the selected pods and name it as "http".

    -   The service selector matches pods with the label "app: llama-cpp".

5. Once Service is setup, apply the route to access the content of the llama.cpp runtime web UI:

    ```sh
    oc create -f ./standalone/04-llama-cpp-route.yaml

    route.route.openshift.io/llama-cpp-route created
    ```

    The above YAML file is a Route configuration for NERC OpenShift. It creates a route named "llama-cpp" that directs traffic to the "llama-cpp-service" service, using the "http" target port in "llama-cpp-service". The route is set to use *edge* TLS that exposes the internal service externally with HTTPS termination and insecureEdgeTerminationPolicy set to "Redirect".
    The application associated with this route is labeled as "app: llama-cpp".

6. You can verify the status of the runtime readiness by checking the pod status and its progress, as shown below:

    ```sh
    oc get pods --watch

    NAME                                   READY   STATUS    RESTARTS   AGE
    llama-cpp-deployment-76685c6df-8fd9m   0/1     Init:0/1  0          1m3s
    ```

    After sometime you will see the pod goes to READY 1/1 state.

    ```sh
    oc get pods --watch

    NAME                                    READY   STATUS    RESTARTS   AGE
    llama-cpp-deployment-76685c6df-8fd9m    1/1     Running   0          5m43s
    ```

    Use `CONTROL-C` to break out if you previously used the watch command to monitor the pods building.

**NOTE:** You can run this `oc` command: `oc apply -f ./standalone/.` to execute all of the above described YAML files located in the **standalone** folder at once. To delete all resources if not necessary just run `oc delete -f ./standalone/.` or `oc delete all,pvc -l app=llama-cpp`.
