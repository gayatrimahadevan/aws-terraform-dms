module "vpc1" {
  source          = "./tamodules/vpc"
  cidr            = "143.0.0.0/20"
  name            = "dev-vpc"
  public_subnets  = ["143.0.1.0/24", "143.0.3.0/24"]
  private_subnets = ["143.0.2.0/24","143.0.4.0/24"]
}
