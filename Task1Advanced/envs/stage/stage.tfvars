vm = {
  name        = "future-stage-vm"
  folder_id   = "REPLACE_WITH_STAGE_FOLDER_ID"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  cores       = 2
  memory      = 4
  disk        = { size = 50, type = "network-ssd" }
  boot_disk   = { size = 20, type = "network-ssd" }
  image_id    = "REPLACE_WITH_IMAGE_ID"
  subnet_id   = "REPLACE_WITH_STAGE_SUBNET_ID"
  nat         = true
  ssh_user    = "ubuntu"
}

ssh_key_path = "~/.ssh/id_ed25519.pub"
