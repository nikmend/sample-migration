
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

}

resource "random_id" "job_id" {
  byte_length = 8  # Longitud del ID en bytes (8 bytes generarán un ID hexadecimal de 16 caracteres)
}
# Google Cloud Storage Bucket
resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-sandbox-bucket"
  location = var.region

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 365
    }
  }
}


# BigQuery Dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.dataset_id
  location                   = var.region
  delete_contents_on_destroy = true
  project                    = var.project_id
}


# Service Account
resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = "BigQuery and GCS Service Account"
  project      = var.project_id
}



# Grant roles to Service Account
resource "google_project_iam_binding" "sa_storage_access" {
  role    = "roles/storage.objectAdmin"
  members = ["serviceAccount:${google_service_account.service_account.email}"]
  project = var.project_id
}

resource "google_project_iam_binding" "sa_bigquery_access" {
  role    = "roles/bigquery.dataEditor"
  members = ["serviceAccount:${google_service_account.service_account.email}"]
  project = var.project_id
}


# BigQuery tables
resource "google_bigquery_table" "hired_employees" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "hired_employees"
  schema = jsonencode([
    { "name" : "id", "type" : "INTEGER", "mode" : "REQUIRED" },
    { "name" : "name", "type" : "STRING", "mode" : "REQUIRED" },
    { "name" : "datetime", "type" : "STRING", "mode" : "REQUIRED" },
    { "name" : "department_id", "type" : "INTEGER", "mode" : "REQUIRED" },
    { "name" : "job_id", "type" : "INTEGER", "mode" : "REQUIRED" }
  ])
}

resource "google_bigquery_table" "departments" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "departments"
  schema = jsonencode([
    { "name" : "id", "type" : "INTEGER", "mode" : "REQUIRED" },
    { "name" : "department", "type" : "STRING", "mode" : "REQUIRED" }
  ])
}

resource "google_bigquery_table" "jobs" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "jobs"
  schema = jsonencode([
    { "name" : "id", "type" : "INTEGER", "mode" : "REQUIRED" },
    { "name" : "job", "type" : "STRING", "mode" : "REQUIRED" }
  ])
}
