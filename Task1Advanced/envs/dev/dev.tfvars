vm = {
  name        = "future-dev-vm"
  folder_id   = "REPLACE_WITH_DEV_FOLDER_ID"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  cores       = 2
  memory      = 2
  disk        = { size = 20, type = "network-hdd" }
  boot_disk   = { size = 20, type = "network-hdd" }
  image_id    = "REPLACE_WITH_IMAGE_ID"
  subnet_id   = "REPLACE_WITH_DEV_SUBNET_ID"
  nat         = true
  ssh_user    = "ubuntu"
}

ssh_key_path = "~/.ssh/id_ed25519.pub"
