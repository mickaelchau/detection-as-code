terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = "micka-secops-lab" # Replace with your GCP project ID
  region  = "us-central1"         # Replace with your desired region
}

# Create a GCE VM instance
resource "google_compute_instance" "default" {
  name         = "terraform-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a" # Remove this line if you are not setting zone above.

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    # access_config { } # Include this to assign an ephemeral public IP
  }
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }


}
