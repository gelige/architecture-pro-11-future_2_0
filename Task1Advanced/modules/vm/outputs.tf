output "vm_id" {
  description = "ID виртуальной машины."
  value       = yandex_compute_instance.vm.id
}

output "name" {
  description = "Имя виртуальной машины."
  value       = yandex_compute_instance.vm.name
}

output "private_ip" {
  description = "Внутренний IPv4."
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "public_ip" {
  description = "Публичный IPv4; null при отключённом NAT."
  value       = var.nat ? yandex_compute_instance.vm.network_interface[0].nat_ip_address : null
}

output "disk_id" {
  description = "ID дополнительного диска."
  value       = yandex_compute_disk.data.id
}
