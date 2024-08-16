variable "project_id" {
  description = "Project ID in Google Cloud"
  type        = string
  default     = "silicon-amulet-432102-s9"
}

variable "region" {
  description = "GCP region where resources will be created"
  type        = string
  default     = "us-central1" # Región por defecto
}

variable "dataset_id" {
  description = "The ID of the BigQuery dataset"
  type        = string
  default     = "raw_csv_source"
}

variable "service_account_id" {
  description = "The ID of the service account"
  type        = string
  default     = "common-service-account"
}
