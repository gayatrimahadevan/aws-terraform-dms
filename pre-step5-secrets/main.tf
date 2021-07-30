variable "endpoints" {
  description = "list of endpoins"
  type = map(object({
    database_host     = string
    database_name     = string
    database_username = string
    database_password = string
    database_port     = number
  }))
  default = {
    sqlserver-source = {
      database_name     = "AdventureWorksLT2019"
      database_username = "dms_user"
      database_password = "deloitte.0"
      database_host     = "143.0.1.156"
      database_port     = 1433
    },
    postgres-sqlserver-target = {
      database_host     = "db-ebportal.cqxof8vdhbed.us-east-1.rds.amazonaws.com"
      database_name     = "customerdb"
      database_username = "customer_appuser"
      database_password = "password02"
      database_port     = 5432
    },
    postgres-oracle-target = {
      database_host     = "db-ebportal.cqxof8vdhbed.us-east-1.rds.amazonaws.com"
      database_name     = "empdb"
      database_username = "emp_appuser"
      database_password = "password02"
      database_port     = 5432
    },
    oracle-source = {
      database_host     = "143.0.1.156"
      database_name     = "ORCLPDB1"
      database_username = "dms_user"
      database_password = "deloitte.0"
      database_port     = "1521"
    }
  }
}
resource "aws_secretsmanager_secret" "dms-cons" {
  name                    = "dms-cons"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "dms-con-details" {
  secret_id     = aws_secretsmanager_secret.dms-cons.id
  secret_string = jsonencode(var.endpoints)
}
