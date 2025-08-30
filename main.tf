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
  public_subnet_ids = module.vpc.public_subnet_ids[*]
  aws_instance_ids  = module.ec2.aws_instance_ids
}

module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids[*]
  user_data          = file("${path.root}/user_data.sh")
}