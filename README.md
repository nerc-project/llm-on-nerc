# LLM on NERC

In this repo you will find resources, examples, recipes to setup and work with LLMs on NERC NERC OpenShift and NERC RHOAI.

## Content

### LLM Inference Servers

The following **LLM Inference Servers** for LLMs can be deployed standalone on the NERC OpenShift:

- [Ollama](llm-servers/ollama/README.md): how to deploy [Ollama](https://github.com/ollama/ollama).

- [llama.cpp](llm-servers/llama.cpp/README.md): how to deploy [llama.cpp](https://github.com/ggml-org/llama.cpp).

### Vector Databases

The following **Databases** can be used as a Vector Store for Retrieval Augmented Generation (RAG) applications:

- [Qdrant](vector-databases/qdrant/README.md): Full recipe to deploy the Qdrant, create a suitable Database for a Vector Store.

- [Milvus](vector-databases/milvus/README.md): Full recipe to deploy the Milvus vector store, in standalone mode.

- [PostgreSQL+pgvector](vector-databases/pgvector/README.md): Full recipe to create an instance of PostgreSQL with the pgvector extension, making it usable as a vector store.
