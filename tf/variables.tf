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
