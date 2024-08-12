resource "google_storage_bucket" "auto-expire" {
  name          = "no-public-access-bucket1-${var.gcp_project_id}"
  location      = var.gcp_region
  force_destroy = true

  public_access_prevention = "enforced"

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 30  # Objects older than 30 days will be deleted
    }
  }
}
