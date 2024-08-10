variable "project_id" {
  description = "Project ID in Google Cloud"
  type        = string
}

variable "region" {
  description = "GCP region where resources will be created"
  type        = string
  default     = "us-central1"                       # Región por defecto
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "my_database"
}

