# Big Data Migration to SQL Database

This project migrates historical data from CSV files in Google Cloud Storage (GCS) to a MySQL database on Google Cloud SQL. It also provides a REST API for receiving and processing new data and includes functionality to back up tables in AVRO format.

## Requirements

- **Google Cloud Platform (GCP)**
  - GCP project with sufficient permissions.
  - JSON credentials file for Terraform authentication.

- **Tools**
  - [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) for infrastructure management.
  - [gcloud CLI](https://cloud.google.com/sdk/gcloud) for GCP operations.

## Infrastructure

This project uses the following GCP resources:

- **GCS Bucket:** Stores CSV files.
- **Cloud SQL (MySQL):** Stores migrated and new data.
- **Cloud Run:** Hosts the REST API.
- **Service Account:** Manages permissions across GCP resources.

