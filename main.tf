resource "google_compute_instance" "test_instance" {
  name         = "terraform-test-instance"
  machine_type = "e2-micro"
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  tags = ["web", "dev"]

  metadata = {
    ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "instance_name" {
  description = "The name of the created instance"
  value       = google_compute_instance.test_instance.name
}

output "instance_ip" {
  description = "The public IP address of the created instance"
  value       = google_compute_instance.test_instance.network_interface[0].access_config[0].nat_ip
}
