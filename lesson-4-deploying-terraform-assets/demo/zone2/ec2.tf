  module "project_ec2" {
   source             = "./modules/ec2"
   instance_count     = 2
   aws_ami            = "ami-0ac3c7153de5be64a"
   public_subnet_ids  = module.vpc.public_subnet_ids
 }