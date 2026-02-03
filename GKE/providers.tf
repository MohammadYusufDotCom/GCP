terraform {
  required_version = "~> 1.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }

  backend "gcs" {
    bucket = "terraform"
    prefix = "terraform/gke_state"
  }
  # backend "local" {
  #   path = "terraform.tfstate"
  # }
}

# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}
provider "time" {}

