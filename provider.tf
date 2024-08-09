terraform {
  backend "remote" {
    organization = "avilashj"

    workspaces {
      name = "gcp-prov"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
