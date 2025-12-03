# Minio

[Minio](https://min.io/) is an open-source, high-performance object storage server compatible with the Amazon S3 API. It provides reliable and scalable storage for cloud-native applications, big data, and AI workloads.

## Content

- `s3-basic.yaml` that automates the setup of a local S3 storage (MinIO) by completing the following tasks:

    -   Deploys a MinIO instance in your OpenShift project namespace.

    -   Generates a random **Root User**, which can also be used as the *Access Key*,
        and a **Root User Password**, which serves as the *Secret Key* for accessing
        both the MinIO API and the MinIO Console.

    -   Installs all required network policies.

- `setup-s3-with-bucket.yaml` that automates the setup by completing the following tasks:

    -   Deploys a MinIO instance in your project namespace.

    -   Creates one storage bucket within the MinIO instance.

    -   Generates a random **Root User**, which can also be used as the *Access Key*,
        and a **Root User Password**, which serves as the *Secret Key* for accessing
        both the MinIO API and the MinIO Console.

    -   Establishes a data connection in your RHOAI project - for a bucket - using the generated credentials.

    -   Installs all required network policies.
