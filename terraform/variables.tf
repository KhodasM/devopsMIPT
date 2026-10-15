variable "nginx_host_port" {
  description = "Нестандартный порт хоста для nginx"
  type        = number
  default     = 8080

  validation {
    condition     = var.nginx_host_port >= 1024 && var.nginx_host_port <= 65535
    error_message = "Порт должен быть в диапазоне 1024..65535."
  }
}
