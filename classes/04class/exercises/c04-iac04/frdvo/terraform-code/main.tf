module "iac-04-module" {
  source = "./iac-04-module"

  ami_id = var.ami_id
  asg_subnets = var.asg_subnets
  scale_instances = var.scale_instances
}