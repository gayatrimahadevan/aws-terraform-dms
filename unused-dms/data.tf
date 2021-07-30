data "aws_vpc" "dev-vpc" {
  filter {
    name   = "tag:Name"
    values = ["dev-vpc"]
  }
}
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.dev-vpc.id
  filter {
    name   = "tag:Name"
    values = ["dev-vpc-public"] # insert values here
  }
}
data "template_file" "table-mappings-from-mssql-to-pg" {
  template = file("./userdata/table-mappings-from-mssql-to-pg.json.tpl")
}
data "template_file" "table-mappings-from-oracle-to-pg" {
  template = file("./userdata/table-mappings-from-oracle-to-pg.json.tpl")
}
data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}
