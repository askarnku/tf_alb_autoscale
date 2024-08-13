# Update default values if threre are conflicts with existing resources

# Define region variable
variable "region" {
  description = "The AWS region to launch the resources."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "subnet_public_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "192.168.100.0/24"
}

variable "subnet_private_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "192.168.200.0/24"
}

# key-pair name from aws
variable "key_name" {
  description = "The name of the key pair to use for the instances"
  type        = string
  default     = "id_ed25519" # Enter your key-pair name
}

# Define the AMI and instance type
variable "ami" {
  description = "The AMI to use for the instances"
  type        = string
  default     = "ami-0ae8f15ae66fe8cda"
}

# Define the instance type
variable "instance_type" {
  description = "The instance type to use for the instances"
  type        = string
  default     = "t2.micro"
}


