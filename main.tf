provider "aws" {
  region = var.region
}

# Let's get you ip from ipinfo.io
data "http" "myip" {
  url = "https://ipinfo.io/ip"
}

locals {
  myip = "${chomp(data.http.myip.response_body)}/32"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "autoscaling-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "autoscaling-public-subnet"
  }
}

# Create a private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "autoscaling-private-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "autoscaling-igw"
  }
}

# create route table to the internet gateway
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "autoscaling-route-table"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

# Associate the private subnet with the route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.main.id
}

# Create a security group for the ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic ipv6
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "ALBSG"
  }
}

# Create a security group for the EC2 instances that accept only traffic from the ALB and ssh from myip
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.myip]
  }

  tags = {
    Name = "EC2SG"
  }
}

# create ALB
resource "aws_lb" "ASALB" {
  name               = "autoscaling-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.private.id]
  tags = {
    Name = "ALB"
  }
}

# create target group
resource "aws_lb_target_group" "main" {
  name     = "autoscaling-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "autoscaling-tg"
  }
}

# launch from template
resource "aws_launch_template" "main_lt" {
  name                   = "ASLT"
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-lt"
    }
  }
    user_data              = filebase64("./user-data.sh")
}

# create autoscaling group
resource "aws_autoscaling_group" "main" {
  desired_capacity = 2
  max_size         = 4
  min_size         = 2
  launch_template {
    id = aws_launch_template.main_lt.id
  }
  vpc_zone_identifier       = [aws_subnet.public.id]
  target_group_arns         = [aws_lb_target_group.main.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance"]
  tag {
    key                 = "Name"
    value               = "autoscaling-asg"
    propagate_at_launch = true
  }
}
