data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Type = "Private"
  }
}
data "aws_secretsmanager_secret" "dms-cons" {
  name = var.secret_name
}
data "aws_secretsmanager_secret_version" "dms-con-details" {
  secret_id = data.aws_secretsmanager_secret.dms-cons.id
}
data "template_file" "table-mappings-from-mssql-to-pg" {
  template = file("./userdata/table-mappings-from-mssql-to-pg.json.tpl")
}

data "template_file" "table-mappings-from-oracle-to-pg" {
  template = file("./userdata/table-mappings-from-oracle-to-pg.json.tpl")
}
