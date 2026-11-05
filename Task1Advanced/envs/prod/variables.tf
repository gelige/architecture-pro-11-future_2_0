variable "vm" {
  description = "Конфигурация ВМ окружения. Размеры дисков и RAM — в ГБ."
  type = object({
    name        = string
    folder_id   = string
    zone        = string
    platform_id = string
    cores       = number
    memory      = number
    disk        = object({ size = number, type = string })
    boot_disk   = object({ size = number, type = string })
    image_id    = string
    subnet_id   = string
    nat         = bool
    ssh_user    = string
  })
}

variable "ssh_key_path" {
  description = "Путь к файлу публичного SSH-ключа."
  type        = string
}
