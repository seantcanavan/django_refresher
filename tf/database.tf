resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.3"  # Update this as per the latest available version
  instance_class       = "db.t2.micro"
  username             = "var.db.user"
  password             = "var.db.pass"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
}

# Optional: You can also create a separate resource for the database itself, if needed.
resource "aws_db_option_group" "default" {
  name                     = "option-group-name"
  option_group_description = "Option Group"
  engine_name              = "postgres"
  major_engine_version     = "13"

  # You can add specific options here if required
}
