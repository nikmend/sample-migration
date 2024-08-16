output "bucket_name" {
  description = "Name of the created bucket"
  value       = google_storage_bucket.bucket.name
}

output "dataset_id" {
  value = google_bigquery_dataset.dataset.dataset_id
}


output "service_account_email" {
  value = google_service_account.service_account.email
}