# Working with Langchain

## Requirements

To work with these examples, you will need a Hugging Face Text Generation Inference (TGI) server deployed as described [here](../../../llm-servers/hf-tgi/README.md), or a Text Generation Inference Service (TGIS) with the `FLAN-T5 Small` model using single-model serving and a serving runtime i.e. `TGIS Standalone ServingRuntime for KServe`, as described [here](https://nerc-project.github.io/nerc-docs/openshift-ai/other-projects/serving-tgis-and-FLAN-T5-Model/).

You can either install LangChain and its dependencies in your workbench (`pip install langchain`), or use the pre-built custom workbench image available on NERC RHOAI called **"Jupyter Langchain CUDA"**, which includes everything you need.

## Content

All the Notebooks in this folder use Langchain to interact with different types of LLM Inference Servers, as well as different types of Vector Databases.

The name of the notebook indicates which elements are used, and the purpose of the notebook. For example:

- `RAG_with_sources_Langchain-Ollama-Qdrant.ipynb` shows how to create a Retrieval Augmented Generation (RAG) pipeline with Langchain, a Qdrant database, and an Ollama Inference Server.

- `Langchain-Ollama-Prompt-memory.ipynb` shows a notebook example to query Ollama with implementing Memory in LangChain.

- `Langchain-HFTGI-Prompt-memory.ipynb` shows a notebook example to the Hugging Face Text Generation Inference (TGI) server with `Llama2`, Langchain and a custom Prompt.

- `Langchain-vLLM-Prompt-memory.ipynb` shows a notebook example to query the vLLM Inference server with `Mistral-7b`, Langchain and a custom Prompt.

Several example notebooks are available to show how to use Milvus vector database:

- Connect and test weather a collection exists or not: `Connect-Milvus.ipynb`

- Collection creation and document ingestion using Langchain: `Langchain-Milvus-Ingest.ipynb`

- Collection creation and document ingestion using Langchain with Nomic AI Embeddings: `Langchain-Milvus-Ingest-nomic.ipynb`

- Query a collection using Langchain: `Langchain-Milvus-Query.ipynb`

- Query a collection using Langchain with Nomic AI Embeddings: `Langchain-Milvus-Query-nomic.ipynb`
