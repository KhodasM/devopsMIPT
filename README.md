# ДЗ #1: Фундамент DevOps-инфраструктуры

Проект содержит базовый каркас сквозного развёртывания: Terraform создаёт инфраструктуру, Ansible настраивает хост, Bash проверяет состояние сервиса, а Docker Compose запускает связку reverse proxy и приложения.

## Структура

```text
terraform/                 # IaC (провайдер и ресурсы выбранной среды)
ansible/inventory.ini.example
ansible/setup_host.yml     # Docker, deployer и автозапуск
compose/                   # nginx reverse proxy + app
scripts/monitor.sh         # проверка systemd и ошибок syslog
```

## Порядок запуска

1. Выбрать облако или локальный гипервизор и заполнить `terraform/terraform.tfvars`.
2. Выполнить `terraform init`, `terraform validate`, `terraform plan`, `terraform apply`.
3. Заполнить `ansible/inventory.ini` IP-адресом VM и проверить SSH-доступ.
4. Запустить `ansible-playbook -i ansible/inventory.ini ansible/setup_host.yml` два раза. Во втором запуске ожидается `changed=0` для уже настроенных ресурсов.
5. Скопировать каталог `compose` на VM в `/opt/app` и выполнить `docker compose up -d`.
6. Проверить `docker compose ps`, `curl http://<VM_IP>` и `scripts/monitor.sh docker`.

## Проверки для отчёта

Сохраните в `screenshots/` или вставьте в этот README результаты:

```bash
terraform state list
ansible-playbook -i ansible/inventory.ini ansible/setup_host.yml   # второй запуск
./scripts/monitor.sh docker
docker compose ps
curl http://<VM_IP>
```

## Архитектурные решения

Сеть и VM описываются декларативно Terraform, конфигурация хоста выполняется идемпотентным Ansible, а приложение запускается одинаково через Compose. SSH должен быть разрешён только с вашего публичного IP и только по ключу.

