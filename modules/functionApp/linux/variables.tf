variable "project" {
  type = string
  description = "Project name"
}

variable "environment" {
  type = string
  #description = "Environment (dev / stage / prod)"
  description = "dev"
}

variable "location" {
  type = string
  description = "Azure region"
}

variable "OS_Type" {
  type = string
  description = "linux"
}
