output "nginx_url" {
  description = "URL Terraform-managed nginx"
  value       = "http://localhost:${var.nginx_host_port}"
}

output "network_name" {
  value = docker_network.nginx.name
}

output "volume_name" {
  value = docker_volume.nginx_cache.name
}
