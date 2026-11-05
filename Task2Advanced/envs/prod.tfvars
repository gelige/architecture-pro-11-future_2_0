vm = {
  name        = "future-ci-prod-vm"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  cores       = 4
  memory      = 8
  disk        = { size = 100, type = "network-ssd" }
  boot_disk   = { size = 30, type = "network-ssd" }
  nat         = false
  ssh_user    = "ubuntu"
}
