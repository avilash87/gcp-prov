# resource "google_storage_bucket" "auto-expire" {
#   name          = "no-public-access-bucket-${var.gcp_project_id}-${var.bucket_suffix}"
#   location      = var.gcp_region
#   force_destroy = true

#   public_access_prevention = "enforced"

#   lifecycle_rule {
#     action {
#       type = "Delete"
#     }

#     condition {
#       age = 30  # Objects older than 30 days will be deleted
#     }
#   }
# }
