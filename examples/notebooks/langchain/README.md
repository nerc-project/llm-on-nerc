# Working with Langchain

## Content

All the Notebooks in this folder use Langchain to interact with different types of LLM Inference Servers, as well as different types of Vector Databases.

The name of the notebook indicates which elements are used, and the purpose of the notebook. For example:

- `RAG_with_sources_Langchain-Ollama-Qdrant.ipynb` shows how to create a Retrieval Augmented Generation (RAG) pipeline with Langchain, a Qdrant database, and an Ollama Inference Server.

- `Langchain-Ollama-Prompt-memory.ipynb` shows a notebook example to query Ollama with implementing Memory in LangChain.

Several example notebooks are available to show how to use Milvus vector database:

- Connect and test weather a collection exists or not: `Connect-Milvus.ipynb`

- Collection creation and document ingestion using Langchain: `Langchain-Milvus-Ingest.ipynb`

- Collection creation and document ingestion using Langchain with Nomic AI Embeddings: `Langchain-Milvus-Ingest-nomic.ipynb`

- Query a collection using Langchain: `Langchain-Milvus-Query.ipynb`

- Query a collection using Langchain with Nomic AI Embeddings: `Langchain-Milvus-Query-nomic.ipynb`
