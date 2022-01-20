resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_service_account" "dle_service_account" {
  account_id = "dle-service-account"
  display_name = "DLE-SA"
}

#resource "google_project_iam_binding" "firestore_owner_binding" {
#  role               = "roles/datastore.owner"
#  members = [
#    "serviceAccount:sa-name@${var.project}.iam.gserviceaccount.com",
#  ]
#  depends_on = [google_service_account.sa-name]
#}

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

  service_account {
    email = "dle-service-account@postgres-ai.iam.gserviceaccount.com"
    scopes = ["storage-ro"]
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh_key.public_key_openssh}"
  }
  provisioner "local-exec" { # save private key locally
    command = "echo '${tls_private_key.ssh_key.private_key_pem}' > ./dle.pem"
  }
  provisioner "local-exec" {
    command = "chmod 600 ./dle.pem"
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

