# Configuration Terraform
terraform {
  required_version = ">= 1.6"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Provider Docker (local)
provider "docker" {}

locals {
  common_tags = {
    project     = var.app_name
    environment = var.environment
    managed_by  = "terraform"
  }

  container_name = "${var.app_name}-${var.environment}"
}

data "docker_network" "bridge" {
  name = "bridge"
}

# --- Réseau ---
resource "docker_network" "app_network" {
  name = "devops-network-${var.environment}"
}

# --- Image app ---
resource "docker_image" "app" {
  name         = "devops-app:1.0.0"   # ou l'image construite localement
  keep_locally = true
}

resource "docker_container" "app" {
  name  = "${var.app_name}-${var.environment}"
  image = docker_image.app.image_id
  ports {
    internal = 3000
    external = var.web_port
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
}

# --- Outputs ---
output "web_url" {
  value       = "http://localhost:${docker_container.app.ports[0].external}"
  description = "URL du serveur web"
}

output "container_id" {
  value = docker_container.app.id
}

output "container_name" {
  value = docker_container.app.name
}
