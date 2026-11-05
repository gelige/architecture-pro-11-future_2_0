terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.140.0"
    }
  }
}

resource "yandex_compute_disk" "data" {
  name      = "${var.name}-data"
  folder_id = var.folder_id
  zone      = var.zone
  type      = var.disk.type
  size      = var.disk.size
}

resource "yandex_compute_instance" "vm" {
  name        = var.name
  folder_id   = var.folder_id
  zone        = var.zone
  platform_id = var.platform_id

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.boot_disk.size
      type     = var.boot_disk.type
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.data.id
    device_name = "data"
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${trimspace(var.ssh_key)}"
  }
}
