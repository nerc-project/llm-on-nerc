# PostgreSQL + pgvector

[pgvector](https://github.com/pgvector/pgvector) is an open-source extension for
PostgreSQL that allows efficient storage, indexing, and querying of high-dimensional
vector embeddings for similarity search. It seamlessly integrates with PostgreSQL,
making it ideal for AI applications such as recommendation systems, image retrieval,
and natural language processing (NLP).

Store your vectors with the rest of your data. Supports:

-   exact and approximate nearest neighbor search

-   L2 distance, inner product, and cosine distance

-   any language with a Postgres client

Plus ACID compliance, point-in-time recovery, JOINs, and all of the other great features of Postgres.

## Deployment procedure

1. **Clone** or navigate to [this repository](https://github.com/nerc-project/llm-on-nerc.git).

    To get started, clone the repository using:

    ```sh
    git clone https://github.com/nerc-project/llm-on-nerc.git
    cd llm-on-nerc/vector-databases/pgvector
    ```

2. In the `standalone` folder, you will find the following YAML files that allow you to easily deploy a **PostgreSQL + pgvector** instance:

    -   `01-db-pgvector-secret.yaml`: the secret that will define the database name as well as the user name and password to connect to it. Change these database keys' values with your own!

    -   `02-pgvector-pvc.yaml`: an example of PVC needed to persist the database. If you don't have a default storage class you must add it. Adjust the size according to your needs.

    -   `03-pgvector-deployment.yaml`: deployment of PostgreSQL server.

        ### Container image

        **Very Important:** A prebuilt image is available at [Quay.io](https://quay.io/repository/rh-aiservices-bu/postgresql-15-pgvector-c9s) and is used as the container image in this deployment. The provided [`Containerfile`](Containerfile) builds a PostgreSQL 15 + pgvector image, where pgvector is compiled from source. You can also build your own custom PostgreSQL image and use it in place of the specified `spec.containers.image`.

    -   `04-pgvector-services.yaml`: service to expose the PostgreSQL server.

You can run this `oc` command: `oc apply -f ./standalone/.` to execute all of the above described YAML files located in the **standalone** folder at once.

```sh
oc apply -f ./standalone/.

secret/postgresql created
persistentvolumeclaim/postgresql created
deployment.apps/postgresql created
service/postgresql created
```

To delete all resources if not necessary just run `oc delete -f ./standalone/.` or `oc delete all,pvc,secret -l app=pgvector`.

## Usage

After applying all those files you can internally access your PostgreSQL+pgvector server running on port **5432** using http.

This is accessible **within the cluster only**, such as from the NERC RHOAI Workbench hosted Jupyter Notebooks or another pod within your project namespace.

You can use either the service name or the fully qualified internal Hostname for service routing, as shown below:

-   **Option 1:** Using the service name i.e. `http://postgresql:5432`

-   **Option 2:** Using the full internal hostname i.e. `http://postgresql.<your-namespace>.svc.cluster.local:5432`

The `pgvector` extension must be manually enabled in the server. This can only be done as a Superuser (above account won't work). The easiest way is to:

-   Connect to the running server Pod, either through the Terminal view in the NERC OpenShift Console, or through the CLI with:

    `oc rsh services/postgresql`

-   Once connected, enter the following command:

    `psql -d vectordb -c "CREATE EXTENSION vector;"`

    **NOTE:** adapt the command if you changed the **name of the database** in the Secret.

    If the command succeeds, it will print `CREATE EXTENSION`.

-   Exit the terminal

Your vector database is now ready to use!
