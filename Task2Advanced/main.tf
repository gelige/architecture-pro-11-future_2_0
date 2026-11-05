terraform {
  required_version = ">= 1.11.0, < 2.0.0"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    region                      = "ru-central1"
    use_lockfile                = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
    # bucket и key передаются скриптом init; credentials — через AWS_*.
  }

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.140.0"
    }
  }
}

provider "yandex" {
  folder_id = var.folder_id
  zone      = var.vm.zone
}

module "vm_module" {
  source = "../Task1Advanced/modules/vm"

  name        = var.vm.name
  folder_id   = var.folder_id
  zone        = var.vm.zone
  platform_id = var.vm.platform_id
  cores       = var.vm.cores
  memory      = var.vm.memory
  disk        = var.vm.disk
  boot_disk   = var.vm.boot_disk
  image_id    = var.image_id
  subnet_id   = var.subnet_id
  nat         = var.vm.nat
  ssh_user    = var.vm.ssh_user
  ssh_key     = var.ssh_key
}
