variable "vpc_id" {
  type        = string
  description = "VPC you will use"
}

variable "asg_subnets" {
  type = list(string)
}

variable "homecidr" {
  type        = string
  description = "CIDR to ssh from home"
}

variable "scale_up_by" {
  type = number
}
variable "scale_down_by" {
  type        = number
  description = "Must be negative number"
}