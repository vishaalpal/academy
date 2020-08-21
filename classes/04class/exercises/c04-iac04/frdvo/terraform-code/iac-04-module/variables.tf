variable "ami_id" {
  description = "ami to be used on the deployment"
  type        = string
}

variable "asg_subnets" {
  type = list(string)
}

variable "homecidr" {
  type = string
  description = "IP to ssh from home"
}

variable "asg_min" {
  type        = number
  description = "ASG minimum number of hosts"
  default     = 1
}

variable "asg_max" {
  type        = number
  description = "ASG maximum number of hosts"
  default     = 3
}

variable "scale_up_by" {
  type = number
}
variable "scale_down_by" {
  type = number
  description = "Must be negative number"
}
