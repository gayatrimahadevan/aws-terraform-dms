resource "aws_instance" "build" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.medium"
  key_name      = "acg"
  root_block_device {
    volume_size = 45
    volume_type = "gp3"
  }
  # the VPC subnet
  subnet_id = tolist(data.aws_subnet_ids.public.ids)[0]

  # the security group
  vpc_security_group_ids = [
    aws_security_group.sg-allow-db.id
  ]

  tags = {
    Name = "DatabaseServer"
  }
}

output "buildip" {
  value = aws_instance.build.public_ip
}

