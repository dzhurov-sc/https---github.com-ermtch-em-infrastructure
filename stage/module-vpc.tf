module "vpc" {
  source       = "../modules/vpc"
  env          = var.env
  project_name = var.project_name

  vpc_cidr             = "10.10.0.0/16"
  public_subnets_cidr  = ["10.10.10.0/24", "10.10.20.0/24"]
  private_subnets_cidr = ["10.10.100.0/24", "10.10.200.0/24"] # Should be at least two, for database creating
  availability_zones   = ["${var.region}a", "${var.region}b"] # Should be at least two, for database creating

  main_sg = local.main_sg
}

output "vpc_id" { value = module.vpc.vpc_id }
output "availability_zones" { value = module.vpc.availability_zones }
output "public_subnets" { value = module.vpc.public_subnets }
output "private_subnets" { value = module.vpc.private_subnets }