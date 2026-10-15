# ДЗ #1: Фундамент DevOps-инфраструктуры

Проект выполняется в порядке, указанном преподавателем: сначала Ansible (пункт 3), затем Terraform с Docker provider (пункт 2), после этого мониторинг и Docker Compose.

## Структура

```text
terraform/                 # Terraform + kreuzwerker/docker
ansible/inventory.ini.example
ansible/setup_host.yml     # Docker, deployer и автозапуск
compose/                   # nginx reverse proxy + app в отдельной сети Compose
scripts/monitor.sh         # проверка systemd и ошибок syslog
```

## Этап 1. Ansible

1. Установить Ansible на управляющей машине или использовать WSL/Linux.
2. Скопировать `ansible/inventory.ini.example` в `ansible/inventory.ini` и указать адрес Linux-хоста.
3. Установить коллекцию:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

4. Запустить playbook два раза:

```bash
ansible-playbook -i ansible/inventory.ini ansible/setup_host.yml
ansible-playbook -i ansible/inventory.ini ansible/setup_host.yml
```

Во втором запуске для уже настроенных задач ожидается `changed=0`.

## Этап 2. Terraform + Docker provider

Terraform создаёт отдельные Docker network, volume и nginx-контейнер. Nginx доступен на нестандартном порту `8080`, а контейнеры Compose работают в своей сети `compose_app_net`.

```powershell
cd terraform
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
curl.exe -i http://localhost:8080
terraform state list
```

## Этап 3. Мониторинг

На Linux-хосте:

```bash
chmod +x scripts/monitor.sh
./scripts/monitor.sh docker
```

Если сервис неактивен, скрипт печатает последние 10 строк `journalctl`; также считает ошибки в `/var/log/syslog` за текущий и предыдущий час.

## Этап 4. Docker Compose

Compose намеренно использует отдельную сеть для `nginx` и `app`:

```bash
cd compose
docker compose up -d
docker compose ps
curl -i http://localhost
```

## Git workflow

```bash
git switch -c feature/infra-setup
git add .
git commit -m "feat: add Ansible and Docker Terraform infrastructure"
git push -u origin feature/infra-setup
```

После проверки создайте Pull Request из `feature/infra-setup` в `main`, выполните само-ревью, после merge создайте тег `v0.1.0`.

Не коммитьте `terraform.tfvars`, ключи, `.terraform/` или `*.tfstate`.
