data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

module "iac-04-module" {
  source = "./iac-04-module"

  ami_id        = data.aws_ami.amazon-linux-2.id
  asg_subnets   = var.asg_subnets
  homecidr      = var.homecidr
  scale_up_by   = var.scale_up_by
  scale_down_by = var.scale_down_by
}