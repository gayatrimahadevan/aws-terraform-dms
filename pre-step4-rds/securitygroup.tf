locals {
  ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
}
resource "aws_security_group" "allow-pgdb" {
  vpc_id      = data.aws_vpc.dev-vpc.id
  name        = "allow-pgdb"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${local.ifconfig_co_json.ip}/32", data.aws_vpc.dev-vpc.cidr_block]
  }
  tags = {
    Name         = "sg-allow-pgdb",
    "AllowedUse" = "Internal"
  }
}
