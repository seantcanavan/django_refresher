resource "aws_db_instance" "django-psql-db" {
  allocated_storage    = 20
  db_subnet_group_name = "default-sean"
  engine               = "postgres"
  engine_version       = "16.3"  # Update this as per the latest available version
  identifier           = "django-psql-db-${var.stage}"
  instance_class       = "db.t2.micro"
  kms_key_id           = aws_kms_key.django-psql-db-key.arn
  parameter_group_name = "default.postgres13"
  password             = "var.db.pass"
  skip_final_snapshot  = true
  storage_encrypted    = true
  storage_type         = "gp2"
  username             = "var.db.user"
}


# KMS Key for database encryption
resource "aws_kms_key" "django-psql-db-key" {
  description         = "KMS key for database encryption"
  enable_key_rotation = true
}
