# Модульная инфраструктура: dev, stage, prod

Используется Yandex Cloud, Terraform >= 1.5 и < 2.0, провайдер `yandex-cloud/yandex ~> 0.140.0`.
`modules/vm` создаёт одну ВМ, загрузочный и отдельный дополнительный диск,
сетевой интерфейс в существующей подсети. Подсеть и VPC создаются заранее:
их жизненный цикл независим от ВМ. Дополнительный диск подключён как `data`,
форматирование и монтирование внутри ОС выполняются отдельно.

## Интерфейс модуля

Все параметры обязательны; значений окружений внутри модуля нет.

| Параметр | Тип | Назначение |
| --- | --- | --- |
| `name` | string | Имя ВМ и префикс имени диска |
| `folder_id`, `zone` | string | Каталог и зона доступности |
| `platform_id` | string | Платформа Compute Cloud |
| `cores`, `memory` | number | vCPU и RAM в ГБ |
| `disk` | object({size=number, type=string}) | Дополнительный диск: ГБ и тип |
| `boot_disk` | object({size=number, type=string}) | Загрузочный диск: ГБ и тип |
| `image_id` | string | ID Linux-образа |
| `subnet_id` | string | ID подсети в зоне ВМ |
| `nat` | bool | Выделять публичный IPv4 |
| `ssh_user`, `ssh_key` | string | Пользователь и содержимое публичного SSH-ключа |

Выходы: `vm_id`, `name`, `private_ip`, `public_ip` (null без NAT), `disk_id`.
Окружения экспортируют их объектом `vm`: `terraform output vm`.
Каждое окружение вызывает `module "vm_module"` из `../../modules/vm`.
Вход `vm` окружения объединяет параметры, кроме `ssh_key`: его содержимое
читается из файла `ssh_key_path` (поддерживается `~`).

| Окружение | vCPU | RAM, ГБ | Дополнительный диск | Публичный IP |
| --- | ---: | ---: | --- | --- |
| dev | 2 | 2 | 20 ГБ HDD | Да |
| stage | 2 | 4 | 50 ГБ SSD | Да |
| prod | 4 | 8 | 100 ГБ SSD | Нет |

## Запуск

1. Установите Terraform и настройте CLI `yc` с доступом к нужным каталогам.
2. В каждом `envs/<окружение>/<окружение>.tfvars` замените `REPLACE_WITH_*`
   реальными ID каталога, подсети и образа Ubuntu; проверьте зону подсети
   и путь к публичному ключу. Например, ID образа можно получить командой
   `yc compute image get-latest-from-family ubuntu-2204-lts --folder-id standard-images`.
3. Передайте IAM-токен через окружение: `export YC_TOKEN="$(yc iam create-token)"`.
4. Из корня репозитория выполните команды нужного окружения:

```bash
terraform -chdir=Task1Advanced/envs/dev init
terraform -chdir=Task1Advanced/envs/dev validate
terraform -chdir=Task1Advanced/envs/dev plan -var-file=dev.tfvars
terraform -chdir=Task1Advanced/envs/dev apply -var-file=dev.tfvars

terraform -chdir=Task1Advanced/envs/stage init
terraform -chdir=Task1Advanced/envs/stage validate
terraform -chdir=Task1Advanced/envs/stage plan -var-file=stage.tfvars
terraform -chdir=Task1Advanced/envs/stage apply -var-file=stage.tfvars

terraform -chdir=Task1Advanced/envs/prod init
terraform -chdir=Task1Advanced/envs/prod validate
terraform -chdir=Task1Advanced/envs/prod plan -var-file=prod.tfvars
terraform -chdir=Task1Advanced/envs/prod apply -var-file=prod.tfvars
```

Для prod SSH доступен по внутреннему IP через VPN или bastion с маршрутом
в подсеть. Для всех сред правила сети должны разрешать SSH из вашей сети.
State локальный, отдельный в каждой директории окружения; он исключён из Git.
При командной работе используйте отдельный remote state для каждой среды.
Созданные `init` файлы `.terraform.lock.hcl` следует хранить в Git.
Удаление ресурсов выбранной среды: например,
`terraform -chdir=Task1Advanced/envs/dev destroy -var-file=dev.tfvars`.
