vm = {
  name        = "future-prod-vm"
  folder_id   = "REPLACE_WITH_PROD_FOLDER_ID"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  cores       = 4
  memory      = 8
  disk        = { size = 100, type = "network-ssd" }
  boot_disk   = { size = 30, type = "network-ssd" }
  image_id    = "REPLACE_WITH_IMAGE_ID"
  subnet_id   = "REPLACE_WITH_PROD_SUBNET_ID"
  nat         = false
  ssh_user    = "ubuntu"
}

ssh_key_path = "~/.ssh/id_ed25519.pub"
