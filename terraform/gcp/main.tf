resource "google_compute_disk" "dle_zfs_disk" {
  name                      = "dle-zfs-disk${count.index}"
  count                     = 3
  type                      = "pd-ssd"
  zone                      = "us-central1-a"
  size                      = 4
  physical_block_size_bytes = 4096
}

resource "google_compute_instance" "vm_instance" {
  name         = "dmitry-terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

resource "google_compute_attached_disk" "dle_attached_zfs_disk" {
  # Documentation: https://www.terraform.io/docs/language/meta-arguments/count.html
  count    = 3 
  disk     = google_compute_disk.dle_zfs_disk[count.index].id
  instance = google_compute_instance.vm_instance.id
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-dle-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "firewall_dle" {
  name    = "terraform-dle-fw-rule"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080", "1000-2000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

