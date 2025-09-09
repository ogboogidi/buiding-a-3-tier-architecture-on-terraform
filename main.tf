provider "aws" {
  region = "us-east-1"
}



# configuring the vpc

module "vpc" {
  source                       = "./modules/vpc"
  tags                         = local.jupiter_tags
  vpc_cidr_block               = var.vpc_cidr_block
  availability_zone            = var.availability_zone
  public_rtb_cidr_block        = var.public_rtb_cidr_block
  public_subnet_cidr_block     = var.public_subnet_cidr_block
  private_subnet_cidr_block    = var.private_subnet_cidr_block
  db_private_subnet_cidr_block = var.db_private_subnet_cidr_block
}


module "alb" {
  source            = "./modules/ALB"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  jupiter_instance  = module.ec2.jupiter_instance
}

module "ec2" {
  source                    = "./modules/ec2"
  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids
  alb_sg                    = module.alb.alb_sg
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  private_server_subnets_id = module.vpc.private_server_subnets_id
  key_name                  = var.key_name
}


module "database" {
  source                  = "./module/database"
  vpc_id                  = module.vpc.vpc_id
  jupiter_db_subnet_group = module.vpc.jupiter_db_subnet_group
  jupiter_bastion_host_sg = module.ec2.jupiter_bastion_host_sg
  instance_class          = var.instance_class
  username                = var.username
  engine_version          = var.engine_version
}

module "route53" {
  source       = "./module/route53"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}