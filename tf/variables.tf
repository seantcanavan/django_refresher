variable "stage" {
  default     = "integration"
  description = "Deployment stage"
  type        = string
}

variable "django-psql-db-user" {
  default     = "user"
  description = "Django Database User"
  type        = string
}

variable "django-psql-db-pass" {
  default     = "pass"
  description = "Django Database Pass"
  type        = string
}

variable "django-secret-key" {
  default     = "django-insecure-e_8rwh&ywsji&zh=vb9rmd4z0%a!%u(zlge_%g5r^&p49euq%$"
  description = "Django Secret Key"
  type        = string
}

variable "django-psql-db-host" {
  default     = "django-psql-db-integration.csfkk1qfrwcy.us-east-2.rds.amazonaws.com"
  description = "Django Database Host"
  type        = string
}
