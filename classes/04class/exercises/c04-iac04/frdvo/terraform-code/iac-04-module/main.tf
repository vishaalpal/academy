resource "aws_security_group" "da-allow_ssh-tf" {
  name        = "da-allow_ssh-tf"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0a2b7db4956438d22"

  ingress {
    description = "SSH from Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.homecidr]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_allow_ssh"
  }
}

resource "aws_lb" "da-iac-alb" {
   name               = "da-iac-alb"
   load_balancer_type = "application"
   subnets            = var.asg_subnets
   internal           = false
   security_groups    = [aws_security_group.da-allow_ssh-tf.id]
}

resource "aws_lb_listener" "da-iac-alb-listener" {
   load_balancer_arn = aws_lb.da-iac-alb.arn
   port              = "80"
   protocol          = "HTTP"

  default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.da-iac-alb-tg.arn
  }
}

resource "aws_launch_configuration" "da-iac-launch-config" {
  name          = "da-iac-launch-config"
  image_id      =  var.ami_id
  instance_type = "t2.micro"
  key_name		= "da"
  associate_public_ip_address = true
  user_data       = <<EOF
  #! /bin/bash
  yum update -y
  yum install -y httpd
  curl 169.254.169.254/latest/meta-data/hostname > index.html
  mv index.html /var/www/html/
  systemctl start httpd
  EOF

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "da-iac-asg" {
  name                      = "da-iac-asg"
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  launch_configuration      = aws_launch_configuration.da-iac-launch-config.name
  vpc_zone_identifier       = var.asg_subnets
  target_group_arns         = [aws_lb_target_group.da-iac-alb-tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_policy" "da-iac-as-policy-increase" {
  name                   = "da-iac-as-policy-increase"
  scaling_adjustment     = var.scale_up_by
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.da-iac-asg.name
}

resource "aws_autoscaling_policy" "da-iac-as-policy-decrease" {
  name                   = "da-iac-as-policy-decrease"
  scaling_adjustment     = var.scale_down_by
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.da-iac-asg.name
}

resource "aws_lb_target_group" "da-iac-alb-tg" {
   name     = "da-iac-alb-tg"
   port     = 80
   protocol = "HTTP"
   vpc_id   = "vpc-0a2b7db4956438d22"
}

resource "aws_cloudwatch_metric_alarm" "doa_asg_cw_alarm_scale_up" {
    alarm_name = "doa-asg-cw-alarm-scale_up"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "10"
    metric_name = "CPUUtilization"
    namespace = "AWS/AutoScaling"
    period = "60"
    statistic = "Average"
    threshold = "80"
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.da-iac-asg.name
    }
    alarm_description = "Increase capacity if CPU utilization >=80 percent for 10 consecutive periods of 60 seconds"
    alarm_actions = [aws_autoscaling_policy.da-iac-as-policy-increase.arn]
}

resource "aws_cloudwatch_metric_alarm" "doa_asg_cw_alarm_scale_down" {
    alarm_name = "doa-asg-cw-alarm-scale-down"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = "10"
    metric_name = "CPUUtilization"
    namespace = "AWS/AutoScaling"
    period = "60"
    statistic = "Average"
    threshold = "80"
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.da-iac-asg.name
    }
    alarm_description = "Decrease capacity if CPU utilization <80 percent for 10 consecutive periods of 60 seconds"
    alarm_actions = [aws_autoscaling_policy.da-iac-as-policy-decrease.arn]
}
