data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["dev-vpc-private"] # insert values here
  }
}
