terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "app" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "app" {
  count = var.replicas
  name  = "${var.app_name}-${var.environment}-${count.index}"
  image = docker_image.app.image_id

  ports {
    internal = var.internal_port
    external = var.external_port_start + count.index
  }

  networks_advanced {
    name = var.network_id
  }

  labels {
    label = "app"
    value = var.app_name
  }
  labels {
    label = "env"
    value = var.environment
  }
}