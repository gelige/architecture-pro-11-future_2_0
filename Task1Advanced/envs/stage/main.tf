terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.140.0"
    }
  }
}

provider "yandex" {
  folder_id = var.vm.folder_id
  zone      = var.vm.zone
}

module "vm_module" {
  source = "../../modules/vm"

  name        = var.vm.name
  folder_id   = var.vm.folder_id
  zone        = var.vm.zone
  platform_id = var.vm.platform_id
  cores       = var.vm.cores
  memory      = var.vm.memory
  disk        = var.vm.disk
  boot_disk   = var.vm.boot_disk
  image_id    = var.vm.image_id
  subnet_id   = var.vm.subnet_id
  nat         = var.vm.nat
  ssh_user    = var.vm.ssh_user
  ssh_key     = file(pathexpand(var.ssh_key_path))
}
