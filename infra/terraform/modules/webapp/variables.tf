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

variable "internal_port" {
  type    = number
  default = 3000
}

variable "external_port_start" {
  type    = number
  default = 3000
}

variable "replicas" {
  type    = number
  default = 1
}

variable "network_id" {
  type = string
}