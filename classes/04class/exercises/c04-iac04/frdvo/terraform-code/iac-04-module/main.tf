resource "aws_security_group" "da-allow_ssh-tf" {
  name = "da-allow_ssh-tf"
  description = "Allow SSH inbound traffic"
  vpc_id = "vpc-0a2b7db4956438d22"

  ingress {
    description = "SSH from Home"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "122.199.23.68/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "alb_allow_ssh"
  }
}

resource "aws_launch_configuration" "da-iac-launch-config" {
  name = "da-iac-launch-config"
  image_id = var.ami_id
  instance_type = "t2.micro"
  key_name = "da"
  associate_public_ip_address = true
  user_data = <<EOF
  #! /bin/bash
  yum update -y
  yum install -y httpd
  curl 169.254.169.254/latest/meta-data/hostname > index.html
  mv index.html /var/www/html/
  systemctl start httpd
  EOF

}

resource "aws_autoscaling_group" "da-iac-asg" {
  name = "da-iac-asg"
  max_size = "3"
  min_size = "1"
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = "2"
  force_delete = true
  launch_configuration = aws_launch_configuration.da-iac-launch-config.name
  vpc_zone_identifier = var.asg_subnets
  depends_on = [
    aws_launch_configuration.da-iac-launch-config]

}

resource "aws_autoscaling_policy" "da-iac-as-policy" {
  name = "da-iac-as-policy"
  scaling_adjustment = var.scale_instances
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.da-iac-asg.name
}


resource "aws_lb" "da-iac-alb" {
  name = "da-iac-alb"
  load_balancer_type = "application"
  subnets = var.asg_subnets
  internal = false
  security_groups = [
    aws_security_group.da-allow_ssh-tf.id]
}

resource "aws_lb_target_group" "da-iac-alb-tg" {
  name = "da-iac-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-0a2b7db4956438d22"
}


resource "aws_lb_listener" "da-iac-alb-listener" {
  load_balancer_arn = aws_lb.da-iac-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.da-iac-alb-tg.arn
  }
}