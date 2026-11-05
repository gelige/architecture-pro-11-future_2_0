variable "name" {
  description = "Имя ВМ; также используется как префикс имени диска."
  type        = string
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud."
  type        = string
}

variable "zone" {
  description = "Зона доступности ВМ, диска и переданной подсети."
  type        = string
}

variable "platform_id" {
  description = "Платформа Compute Cloud."
  type        = string
}

variable "cores" {
  description = "Количество vCPU, поддерживаемое выбранной платформой."
  type        = number
  validation {
    condition     = var.cores > 0 && floor(var.cores) == var.cores
    error_message = "Количество vCPU должно быть целым положительным числом."
  }
}

variable "memory" {
  description = "Объём RAM в ГБ."
  type        = number
  validation {
    condition     = var.memory > 0
    error_message = "Объём RAM должен быть положительным."
  }
}

variable "disk" {
  description = "Дополнительный диск: размер в ГБ и тип хранилища."
  type = object({
    size = number
    type = string
  })
  validation {
    condition     = var.disk.size > 0 && floor(var.disk.size) == var.disk.size
    error_message = "Размер диска должен быть целым положительным числом."
  }
}

variable "boot_disk" {
  description = "Загрузочный диск: размер в ГБ и тип хранилища."
  type = object({
    size = number
    type = string
  })
  validation {
    condition     = var.boot_disk.size > 0 && floor(var.boot_disk.size) == var.boot_disk.size
    error_message = "Размер загрузочного диска должен быть целым положительным числом."
  }
}

variable "image_id" {
  description = "ID Linux-образа с поддержкой SSH-ключей из metadata."
  type        = string
}

variable "subnet_id" {
  description = "ID существующей подсети в выбранной зоне."
  type        = string
}

variable "nat" {
  description = "Выделять ли публичный IPv4 для сетевого интерфейса."
  type        = bool
}

variable "ssh_user" {
  description = "Пользователь SSH, поддерживаемый выбранным образом."
  type        = string
}

variable "ssh_key" {
  description = "Содержимое публичного SSH-ключа OpenSSH."
  type        = string
}
