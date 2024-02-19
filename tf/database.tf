locals {
  instance_class = var.stage == "production" ? "db.t4g.micro" : var.stage == "staging" ? "db.t4g.micro" : "db.t4g.micro"
}


resource "aws_db_instance" "django-psql-db" {
  allocated_storage    = 20
  #  db_name              = "mydb"
  db_subnet_group_name = "default-sean"
  engine               = "postgres"
  engine_version       = "16.1"  # Update this as per the latest available version
  identifier           = "django-psql-db-${var.stage}"
  instance_class       = local.instance_class
  kms_key_id           = aws_kms_key.django-psql-db-key.arn
  parameter_group_name = "postgres16-sean-pgroup"
  password             = var.django-psql-db-pass
  publicly_accessible  = true
  skip_final_snapshot  = true
  storage_encrypted    = true
  storage_type         = "gp3"
  username             = var.django-psql-db-user
}


# KMS Key for database encryption
resource "aws_kms_key" "django-psql-db-key" {
  description         = "KMS key for database encryption"
  enable_key_rotation = true
}
