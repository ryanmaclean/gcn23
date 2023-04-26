# Set the GCP project and region
provider "google" {
  project = "<your-project-id>"
  region  = "us-central1"
}

# Define a variable for the Docker image
variable "docker_image" {
  default = "datadog/docker-dd-agent:latest"
}

# Create a new GCP compute instance
resource "google_compute_instance" "datadog_instance" {
  name         = "datadog-instance"
  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  # Define a startup script to install Docker and run the Datadog container
  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Install Docker
    apt-get update
    apt-get install -y docker.io

    # Run the Datadog container with persistent storage
    docker run -d \
      -p 8126:8126 \
      --name datadog \
      --mount type=volume,source=datadog,target=/etc/dd-agent \
      ${var.docker_image}
  EOF

  # Create a persistent disk to store the Datadog agent configuration
  lifecycle {
    ignore_changes = [attached_disk]
  }

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    size_gb     = 10
    type        = "pd-standard"
    mode        = "READ_WRITE"
    auto_delete = false

    # Attach the disk to the instance
    attachment {
      device_name = "datadog"
      mode        = "READ_WRITE"
    }
  }
}

# Create a firewall rule to allow incoming traffic on port 8126
resource "google_compute_firewall" "allow_dd" {
  name    = "allow-dd"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8126"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [google_compute_instance.datadog_instance.self_link]
}
