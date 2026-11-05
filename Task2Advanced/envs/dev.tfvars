vm = {
  name        = "future-ci-dev-vm"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  cores       = 2
  memory      = 2
  disk        = { size = 20, type = "network-hdd" }
  boot_disk   = { size = 20, type = "network-hdd" }
  nat         = true
  ssh_user    = "ubuntu"
}
