variable "gcp_project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "gcp_region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}
