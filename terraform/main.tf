resource "docker_network" "nginx" {
  name   = "tf-nginx-network"
  driver = "bridge"
}

resource "docker_volume" "nginx_cache" {
  name = "tf-nginx-cache"
}

resource "docker_image" "nginx" {
  name         = "nginx:1.27-alpine"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name    = "tf-nginx"
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = var.nginx_host_port
  }

  networks_advanced {
    name = docker_network.nginx.name
  }

  # Volume подключён к кэшу nginx, чтобы не скрывать index.html из образа.
  volumes {
    volume_name    = docker_volume.nginx_cache.name
    container_path = "/var/cache/nginx"
  }
}
