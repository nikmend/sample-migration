resource "google_storage_bucket_object" "hired_employees" {
  name   = "hired_employees.csv"
  bucket = google_storage_bucket.bucket.name
  source = "../historical_data/hired_employees.csv"

  depends_on = [google_storage_bucket.bucket]
}

resource "google_storage_bucket_object" "departments" {
  name   = "departments.csv"
  bucket = google_storage_bucket.bucket.name
  source = "../historical_data/departments.csv"

  depends_on = [google_storage_bucket.bucket]
}

resource "google_storage_bucket_object" "jobs" {
  name   = "jobs.csv"
  bucket = google_storage_bucket.bucket.name
  source = "../historical_data/jobs.csv"

  depends_on = [google_storage_bucket.bucket]
}



resource "google_bigquery_job" "load_hired_employees" {
  job_id   = "load-hired_employees-job-${random_id.job_id.hex}"
  location = var.region
  load {
    source_uris = [
      "gs://${google_storage_bucket.bucket.name}/hired_employees.csv",
    ]

    destination_table {
      project_id = var.project_id
      dataset_id = google_bigquery_dataset.dataset.dataset_id
      table_id   = "hired_employees"
    }

    write_disposition     = "WRITE_APPEND"
    source_format         = "CSV"
    ignore_unknown_values = true
    max_bad_records       = 1000
    allow_jagged_rows     = true

  }
  depends_on = [google_storage_bucket_object.hired_employees]

  lifecycle {
    create_before_destroy = true
  }
}


resource "google_bigquery_job" "load_departments" {
  job_id   = "load-departments-job-${random_id.job_id.hex}"
  location = var.region
  load {
    source_uris = [
      "gs://${google_storage_bucket.bucket.name}/departments.csv",
    ]

    destination_table {
      project_id = var.project_id
      dataset_id = google_bigquery_dataset.dataset.dataset_id
      table_id   = "departments"
    }
    source_format         = "CSV"
    ignore_unknown_values = true
    max_bad_records       = 1000
    allow_jagged_rows     = true
    write_disposition     = "WRITE_APPEND"

  }
  depends_on = [google_storage_bucket_object.departments]

  lifecycle {
    create_before_destroy = true
  }
}



resource "google_bigquery_job" "load_jobs" {
  job_id   = "load-jobs-job-${random_id.job_id.hex}"
  location = var.region
  load {
    source_uris = [
      "gs://${google_storage_bucket.bucket.name}/jobs.csv",
    ]

    destination_table {
      project_id = var.project_id
      dataset_id = google_bigquery_dataset.dataset.dataset_id
      table_id   = "jobs"
    }
    source_format         = "CSV"
    ignore_unknown_values = true
    max_bad_records       = 1000
    allow_jagged_rows     = true
    write_disposition     = "WRITE_APPEND"

  }
  depends_on = [google_storage_bucket_object.jobs]

  lifecycle {
    create_before_destroy = true
  }
}