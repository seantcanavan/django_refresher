resource "aws_apprunner_service" "django-app-runner" {
  service_name = "django-${var.stage}"

  source_configuration {
    auto_deployments_enabled = true

    code_repository {
      repository_url = "https://github.com/seantcanavan/django_refresher"
      source_code_version {
        type  = "BRANCH"
        value = "django-${var.stage}" # Replace with your branch name
      }

      code_configuration {
        configuration_source = "API"
        code_configuration_values {
          runtime                       = "PYTHON_3"
          start_command                 = "python manage.py collectstatic && gunicorn --workers 2 myproject.wsgi"
          build_command                 = "pip install -r requirements.txt"
          port                          = "8000"
          runtime_environment_variables = {
            "DATABASE_HOST"          = var.django-psql-db-host
            "DATABASE_PASS"          = var.django-psql-db-pass
            "DATABASE_USER"          = var.django-psql-db-user
            "DJANGO_SECRET_KEY"      = var.django-secret-key
            "DJANGO_SETTINGS_MODULE" = "mysite.settings"
          }
        }
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
