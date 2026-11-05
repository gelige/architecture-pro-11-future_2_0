variable "vm" {
  description = "Параметры среды из envs/<среда>.tfvars; RAM и диски в ГБ."
  type = object({
    name        = string
    zone        = string
    platform_id = string
    cores       = number
    memory      = number
    disk        = object({ size = number, type = string })
    boot_disk   = object({ size = number, type = string })
    nat         = bool
    ssh_user    = string
  })
}

variable "folder_id" {
  description = "Каталог выбранной среды, передаётся через TF_VAR_folder_id."
  type        = string
}

variable "subnet_id" {
  description = "Существующая подсеть выбранной среды в зоне vm.zone."
  type        = string
}

variable "image_id" {
  description = "ID образа Ubuntu с поддержкой SSH-ключей из metadata."
  type        = string
}

variable "ssh_key" {
  description = "Содержимое публичного SSH-ключа OpenSSH."
  type        = string
}
