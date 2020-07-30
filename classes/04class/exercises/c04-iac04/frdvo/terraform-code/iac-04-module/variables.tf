variable "ami_id" {
  description = "ami to be used on the deployment"
  type = string
}

variable "asg_subnets" {
  type = list(string)
}

variable "scale_instances" {
  description = "positive number to increase number of instances or negative to decrease"
  type = number
}
