terraform {
  backend "remote" {
    organization = "avilashj"

    workspaces {
      name = "gcp-prov"
    }
  }
}

terraform {

  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.48.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
