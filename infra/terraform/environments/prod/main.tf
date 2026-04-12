terraform {
  required_version = ">= 1.6"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "main" {
  name = "devops-${var.environment}"
}

module "webapp" {
  source              = "../../modules/webapp"
  app_name            = var.app_name
  environment         = var.environment
  image               = var.image
  internal_port       = 3000
  external_port_start = var.web_port
  replicas            = var.web_replicas
  network_id          = docker_network.main.name
}

module "database" {
  source       = "../../modules/database"
  app_name     = var.app_name
  environment  = var.environment
  db_password  = var.db_password
  db_port      = var.db_port
  network_id   = docker_network.main.name
}

variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "image" {
  type    = string
  default = "devops-app:1.0.0"
}

variable "web_port" {
  type = number
}

variable "web_replicas" {
  type = number
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type = number
}

output "web_urls" {
  value = module.webapp.urls
}

output "db_connection" {
  value     = module.database.connection_string
  sensitive = true
}