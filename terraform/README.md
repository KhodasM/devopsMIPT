# Terraform + Docker

Terraform управляет отдельным nginx-контейнером. Ресурсы: образ, новая bridge-сеть, named volume и контейнер. Порт `8080` на хосте пробрасывается в порт `80` контейнера.

## Запуск

Docker Desktop должен быть запущен.

```powershell
cd C:\Users\khoda\devopsMIPT\terraform
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
curl.exe -i http://localhost:8080
terraform state list
```

Ожидаемый ответ начинается с `HTTP/1.1 200 OK` и содержит стандартную страницу nginx.

Удаление созданных Docker-ресурсов после проверки:

```powershell
terraform destroy
```

`terraform.tfvars`, `.terraform/` и `*.tfstate` не должны попадать в Git.
