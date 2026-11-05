# CI/CD и удалённое состояние Terraform

GitHub Actions развёртывает dev, stage или prod в Yandex Cloud через Terraform 1.11.4.
Используется модуль из `Task1Advanced/modules/vm`, параметры сред в `envs/*.tfvars`.

Создаются отдельные ВМ `future-ci-<среда>-vm`; состояние задания 1 не переносится.

## Подготовка

Для каждой среды создайте:

- Приватный бакет Yandex Object Storage с версионированием.
- Сервисный аккаунт backend со статическим ключом и доступом только к своему бакету:
  список объектов, чтение/запись state, чтение/запись/удаление lock-файла.
- Сервисный аккаунт Terraform с авторизованным JSON-ключом, ролями `compute.editor`
  и `vpc.user` на каталог среды и доступом к образу Ubuntu.
- Подсеть в зоне, указанной в `.tfvars`.

State хранится в S3 по ключу `Task2Advanced/<среда>/terraform.tfstate`.
`use_lockfile = true` защищает его от одновременных изменений; ожидание блокировки 5 минут.
Локальный каталог `.terraform` содержит служебные данные и исключён из Git.

## Настройка GitHub

Создайте Environments **dev**, **stage**, **prod** и заполните для каждого:

| Тип      | Имя                      | Значение                              |
|----------|--------------------------|---------------------------------------|
| Variable | `TF_STATE_BUCKET`        | Имя бакета среды                      |
| Variable | `YC_FOLDER_ID`           | ID каталога                           |
| Variable | `YC_SUBNET_ID`           | ID подсети                            |
| Variable | `YC_IMAGE_ID`            | ID образа Ubuntu                      |
| Secret   | `AWS_ACCESS_KEY_ID`      | ID статического ключа backend         |
| Secret   | `AWS_SECRET_ACCESS_KEY`  | Секрет статического ключа backend     |
| Secret   | `YC_SERVICE_ACCOUNT_KEY` | Содержимое авторизованного JSON-ключа |
| Secret   | `SSH_PUBLIC_KEY`         | Публичный SSH-ключ                    |

Ограничьте развёртывание основной веткой. Для prod можно включить required reviewers:
тогда весь job будет ожидать подтверждения перед запуском.

## Запуск pipeline

Workflow: [terraform-task2.yml](terraform-task2.yml).

Для запуска скопируйте его в `.github/workflows/terraform-task2.yml` в корне репозитория.

После слияния PR откройте **Actions → Task2 Terraform → Run workflow**, выберите основную ветку, среду и значение
`apply`:

- **false** — только проверки и план изменений;
- **true** — проверки, новый план и его применение в этом же запуске.

Скрипт `scripts/deploy.sh` выполняет:

1. Проверку аргументов и форматирования Terraform.
2. `init` с S3 backend выбранной среды и `validate`.
3. `plan -var-file=envs/<среда>.tfvars` с сохранением плана во временный файл.
4. `apply` сохранённого плана, если применение разрешено.
5. Удаление временного плана при завершении.

Запуски одной среды выполняются последовательно. Workflow работает только вручную
из основной ветки; PR не получает секреты.

## Локальный запуск

Установите Terraform 1.11.4 и из корня репозитория выполните:

```bash
export TF_STATE_BUCKET='<бакет-dev>'
export AWS_ACCESS_KEY_ID='<ID статического ключа>'
export AWS_SECRET_ACCESS_KEY='<секрет статического ключа>'
export YC_SERVICE_ACCOUNT_KEY_FILE='/absolute/path/to/authorized-key.json'
export TF_VAR_folder_id='<ID каталога dev>'
export TF_VAR_subnet_id='<ID подсети dev>'
export TF_VAR_image_id='<ID образа Ubuntu>'
export TF_VAR_ssh_key="$(cat ~/.ssh/id_ed25519.pub)"
bash Task2Advanced/scripts/deploy.sh dev plan
bash Task2Advanced/scripts/deploy.sh dev apply
```

Для stage/prod замените аргумент и значения переменных. JSON-ключ храните вне репозитория.

Для prod VPN-доступ и NAT-шлюз для исходящего интернета настраиваются отдельно.
