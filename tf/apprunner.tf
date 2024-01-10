resource "aws_apprunner_service" "django-app-runner" {
  service_name = "django-${var.stage}"

  health_check_configuration {
    path                = "/"
    interval            = "20"
    timeout             = "20"
    healthy_threshold   = "1"
    unhealthy_threshold = "10"
    protocol            = "HTTP"
  }

  source_configuration {
    auto_deployments_enabled = true

    code_repository {
      repository_url = "https://github.com/seantcanavan/django_refresher"
      source_code_version {
        type  = "BRANCH"
        value = "django-${var.stage}" # Replace with your branch name
      }


      code_configuration {
        configuration_source = "REPOSITORY"
        code_configuration_values {
          runtime_environment_variables = {
            "DATABASE_HOST" = var.django-psql-db-host
            "DATABASE_PASS" = var.django-psql-db-pass
            "DATABASE_USER" = var.django-psql-db-user
            "SECRET_KEY" = var.django-secret-key
          }
          runtime = "python311"
        }
    }

    authentication_configuration {
      connection_arn = "arn:aws:apprunner:us-east-2:205503630745:connection/seantcanavan-github-connection/a6ab0e9b45bb4f5796c6ce8904eddcf3"
    }
  }

  instance_configuration {
    cpu    = "2048"
    memory = "4096"
  }
}
