terraform {
  backend "gcs" {
    bucket = "dac-demo-tfstate"
    prefix = "terraform/state"
  }
}

provider "google-beta" {
  project = var.project_id # Put your Project ID
}
