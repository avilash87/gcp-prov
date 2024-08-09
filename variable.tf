variable "gcp_project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "gcp_region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "bucket_suffix" {
  description = "bucket suffix"
  type        = string
  default     = "avilash"
}
