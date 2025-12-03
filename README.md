# LLM on NERC

In this repo you will find resources, examples, recipes to setup and work with LLMs on NERC OpenShift and NERC RHOAI.

## Content

### LLM Inference Servers

The following **LLM Inference Servers** for LLMs can be deployed standalone on the NERC OpenShift:

- [Ollama](https://github.com/ollama/ollama): how to deploy [Ollama](llm-servers/ollama/README.md).

- [llama.cpp](https://github.com/ggml-org/llama.cpp): how to deploy [llama.cpp](llm-servers/llama.cpp/README.md).

### Vector Databases

The following **Databases** can be used as a Vector Store for Retrieval Augmented Generation (RAG) applications:

- [Qdrant](vector-databases/qdrant/README.md): Full recipe to deploy the Qdrant, create a suitable Database for a Vector Store.

- [Milvus](vector-databases/milvus/README.md): Full recipe to deploy the Milvus vector store, in standalone mode.

- [PostgreSQL+pgvector](vector-databases/pgvector/README.md): Full recipe to create an instance of PostgreSQL with the pgvector extension, making it usable as a vector store.

### Inference and application examples

- [Langchain examples](examples/notebooks/langchain/README.md): Various notebooks demonstrating how to work with [Langchain](https://www.langchain.com/). Examples are provided for different types of LLM servers (standalone or using the Model Serving stack of NERC OpenShift AI) and different vector databases.

- [UI examples](examples/ui/README.md): Various examples on how to create and deploy a UI to interact with your LLM.

### LLM clients

- [AnythingLLM](llm-clients/anythingllm/README.md): [AnythingLLM](https://anythingllm.com/) is an all-in-one AI application that supports any LLM, any document, and any agent while ensuring full privacy. Here, it is implemented as a NERC RHOAI custom workbench, allowing seamless integration with your LLM and other resources.

- [Open WebUI](llm-clients/openwebui/README.md) is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline. It supports various LLM runners like **Ollama** and **OpenAI-compatible APIs**, with **built-in inference engine** for *RAG*, making it a **powerful AI deployment solution**.

### setup

[This folder](setup/README.md) contains YAML scripts for setting up local S3 storage (MinIO) based on your requirements - whether you need a basic setup without pre-configured buckets or a setup with buckets and data connections in your NERC RHOAI environment.

### MLflow: A Machine Learning Lifecycle Platform

[This folder](mlflow/README.md) contains YAML scripts for deploying MLflow on NERC OpenShift, along with example Python test scripts to run experiments on the deployed setup.
