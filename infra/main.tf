
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = "silicon-amulet-432102-s9"
}

resource "google_storage_bucket" "bucket" {
  name     = "raw-csv"
  location = "US"
}


resource "google_sql_database_instance" "mysql_instance" {
  name             = "mysql-sandbox-instance"
  database_version = "MYSQL_8_0"                   
  region           = var.region                    

  settings {
    tier           = "db-f1-micro"                 
    backup_configuration {
      enabled = true                               
    }
  }

  deletion_protection = false                       
}

resource "google_service_account" "db_service_account" {
  account_id   = "db-service-account"
  display_name = "Service Account for MySQL, GCS, and Cloud Run"
}


resource "google_sql_user" "service_account_user" {
  name     = google_service_account.db_service_account.email
  instance = google_sql_database_instance.mysql_instance.name
  host     = "%"
  password = ""
  }

resource "google_project_iam_member" "cloudsql_access" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.db_service_account.email}"
}

resource "google_storage_bucket_iam_member" "bucket_access" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.db_service_account.email}"
}

output "service_account_email" {
  description = "Service account email"
  value       = google_service_account.db_service_account.email
}