# Richard Tyson WW Platform Engineering Manager Take Home Assessment
# 2/17/2024
# main.tf
# variables.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}
provider "aws" {
  region = "us-east-2"
}
locals {
  # Subnet IDs using tomap to loop through subnet_ids creation
  subnet_ids = tomap({
    "us-east-2a" = "subnet-11111111111"
    "us-east-2b" = "subnet-22222222222"
    "us-east-2c" = "subnet-33333333333"
    "us-east-2b" = "subnet-44444444444"
  })
}
resource "aws_instance" "example" {
  ami           = "ami-11111111111111" # predefined machine instance name
  for_each      = local.subnet_ids
  instance_type = "t2.micro" # Replace with the instance type
}
resource "aws_iam_access_key" "key_example" {
  user = "abcdefgh" # predefined access key
}
output "secret_access_key" {
  value = aws_iam_access_key.key_example.secret
}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-0000000000000"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id #refrencing vpc id
}
resource "aws_acm_certificate" "example" {
  domain_name       = "example.com"
  validation_method = "DNS"
  arn               = var.AWS_ACM_CERT_ARN
  # other ACM certificate configuration...
}
# defined an ALB that listens on port 443 with HTTPS protocol. 
resource "aws_lb" "my_load_balancer" {
  name                       = "my-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.my_security_group.id]
  subnets                    = [aws_subnet.my_subnet.id]
  enable_deletion_protection = false
  tags = {
    Name = "My Load Balancer"
  }
}
# AMI security LB 443 port open
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # lb forward to LB group for distribution based on availability
  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }
}
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  health_check {
    path                = "/health"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
  tags = {
    Name = "My Target Group"
  }
  # forwards traffic to an EC2 instance via a target group. 
  # group are associated with respective security groups and subnets.
}
resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my_ec2_instance.id
  port             = 80
}
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

resource "aws_instance" "web_servers" {
  count         = 5
  ami           = "ami-11111111111111" # actual AMI ID
  instance_type = "t3.large"
  key_name      = "my-key-pair"
  subnet_id     = "subnet-xyz123"

  root_block_device {
    volume_size = 500
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 500 # storage requested
    throughput            = 250 # throughput
    delete_on_termination = true
    volume_type           = "gp2"
  }

  cpu_core_count = 3  # allocated cores at build & configuration
  memory_size    = 12 # minimum memory allocation

  tags = {
    Name = "web-server"
  }
}
# Security Group
resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Security group for web servers"

  # ami security for port 8192 to the load balancer
  ingress {
    from_port   = 8192
    to_port     = 8192
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ami security for port 22 on 10.0.0.0/16
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  vpc_id = "vpc-0000000000000" # provided vpc name 
}

# Load Balancer
resource "aws_elb" "load_balancer" {
  name            = "my-load-balancer"
  security_groups = [aws_security_group.web_server_sg.id]
  instances       = aws_instance.web_servers[*].id
  subnets         = ["subnet-xyz123", "subnet-abc456"]
  listener {
    instance_port     = 8192
    instance_protocol = "tcp"
    lb_port           = 8192
    lb_protocol       = "tcp"
  }
}
# Autoscaling Group
resource "aws_autoscaling_group" "web_asg" {
  name                 = "web-asg"
  desired_capacity     = 5  # default number of nodes
  min_size             = 2  # lowest number of node configured
  max_size             = 10 # max number of nodes configured
  launch_configuration = aws_launch_configuration.web_launch_config.name

  vpc_zone_identifier = ["subnet-xyz123", "subnet-abc456"]
}
# Launch Configuration
resource "aws_launch_configuration" "web_launch_config" {
  name_prefix     = "web-launch-config-"
  image_id        = "ami-11111111111111" # ami id provided
  instance_type   = "t3.large"
  key_name        = "my-key-pair"
  security_groups = [aws_security_group.web_server_sg.id]
  root_block_device {
    volume_size = 500
    volume_type = "gp2"
  }
}