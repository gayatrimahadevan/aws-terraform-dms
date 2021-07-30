data "aws_vpc" "dev-vpc" {
  filter {
    name   = "tag:Name"
    values = ["dev-vpc"]
  }
}
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.dev-vpc.id
  filter {
    name   = "tag:Name"
    values = ["dev-vpc-private"] # insert values here
  }
}
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.dev-vpc.id
  filter {
    name   = "tag:Name"
    values = ["dev-vpc-public"] # insert values here
  }
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["dmsdb2021"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["983569616860"] # Self
}

# data "aws_ami" "ubuntu" {
#  most_recent = true

#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#  }

#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }

#  owners = ["099720109477"] # Canonical
#}
