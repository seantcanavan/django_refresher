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

  instance_configuration {
    cpu    = "2048"
    memory = "4096"
  }

  source_configuration {
    auto_deployments_enabled = true

    code_repository {
      repository_url = "https://github.com/seantcanavan/django_refresher"
      source_code_version {
        type  = "BRANCH"
        value = "django-${var.stage}"
      }


      code_configuration {
        configuration_source = "REPOSITORY"
      }
    }

    authentication_configuration {
      connection_arn = "arn:aws:apprunner:us-east-2:205503630745:connection/seantcanavan-github-connection/a6ab0e9b45bb4f5796c6ce8904eddcf3"
    }
  }
}
