output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}
output "private_rt_id" {
  description = "The ID of the Private Route Table"
  value       = concat(aws_route_table.private.*.id, [""])[0]
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private.*.cidr_block
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public.*.cidr_block
}
output "public_subnets" {
  description = "List of public subnets"
  value       = aws_subnet.public
}
output "private_subnets" {
  description = "List of private subnets"
  value       = aws_subnet.private
}
# output "azs" {
#   description = "A list of availability zones specified as argument to this module"
#   value       = data.aws_availability_zones.azs
# }

# Static values (arguments)
output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}
