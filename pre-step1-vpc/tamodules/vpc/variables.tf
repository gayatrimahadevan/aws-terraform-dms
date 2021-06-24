variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "name" {
  description = "Name of the VPC."
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

