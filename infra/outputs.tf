output "bucket_name" {
  description = "Name of the created bucket"
  value       = google_storage_bucket.bucket.name
}

output "mysql_instance_connection_name" {
  description = "Connection name for MySQL instance"
  value       = google_sql_database_instance.mysql_instance.connection_name
}