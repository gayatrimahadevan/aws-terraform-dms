resource "aws_db_subnet_group" "subnet-db" {
  name       = "subnet-db"
  subnet_ids = data.aws_subnet_ids.public.ids

  tags = {
    Name = "subnet-db"
  }
}
resource "aws_db_parameter_group" "pgdb-parameter-group" {
  name   = "pgdb-parameter-group"
  family = "postgres13"
  parameter {
    name  = "log_connections"
    value = "1"
  }
}
resource "aws_db_instance" "db-ebportal" {
  identifier             = "db-ebportal"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.2"
  username               = "portaladmin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.subnet-db.name
  vpc_security_group_ids = [aws_security_group.allow-pgdb.id]
  parameter_group_name   = aws_db_parameter_group.pgdb-parameter-group.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

