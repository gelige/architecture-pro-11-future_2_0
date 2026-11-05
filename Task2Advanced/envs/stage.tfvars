vm = {
  name        = "future-ci-stage-vm"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  cores       = 2
  memory      = 4
  disk        = { size = 50, type = "network-ssd" }
  boot_disk   = { size = 20, type = "network-ssd" }
  nat         = true
  ssh_user    = "ubuntu"
}
