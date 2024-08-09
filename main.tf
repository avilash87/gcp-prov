resource "google_storage_bucket" "auto-expire" {
  name          = "no-public-access-bucket"
  location      = "${var.gcp_region}"
  force_destroy = true

  public_access_prevention = "enforced"
}