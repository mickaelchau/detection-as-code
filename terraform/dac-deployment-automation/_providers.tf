terraform {
  backend "gcs" {
    bucket = "dac-demo-tfstate"
    prefix = "terraform/state"
  }
}

provider "google-beta" {
  project = var.gcp_project_id # Put your Project ID
}
