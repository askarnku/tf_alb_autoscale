# Update default values for your desired configuration

# Define region variable
variable "region" {
  description = "The AWS region to launch the resources."
  type        = string
  default     = "us-east-1" # Change your desired region
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16" # Change your desired VPC CIDR block
}

variable "subnet_public_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "192.168.100.0/24" # Change your desired public subnet CIDR block
}

variable "subnet_private_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "192.168.200.0/24" # Change to your desired private subnet CIDR block
}

# key-pair name from aws
variable "key_name" {
  description = "The name of the key pair to use for the instances"
  type        = string
  default     = "id_ed25519" # Change to your key-pair name
}

# Define the AMI and instance type
variable "ami" {
  description = "The AMI to use for the instances"
  type        = string
  default     = "ami-0ae8f15ae66fe8cda" # Change your desired AMI
}

# Define the instance type
variable "instance_type" {
  description = "The instance type to use for the instances"
  type        = string
  default     = "t2.micro" # Change your desired instance type
}

# autoscaling settings
variable "min_size" {
  description = "The minimum number of instances in the autoscaling group"
  type        = number
  default     = 2   # Change your desired minimum number of instances
}

variable "max_size" {
  description = "The maximum number of instances in the autoscaling group"
  type        = number
  default     = 4  # Change your desired maximum number of instances
}

variable "desired_capacity" {
  description = "The desired number of instances in the autoscaling group"
  type        = number
  default     = 2 # Change your desired number of instances
}

variable "default_cooldown" {
  description = "Time in seconds that Auto Scaling waits before taking further action after a scaling activity."
  type        = number
  default     = 300 # Change your desired cooldown period
}

variable "default_instance_warmup" {
  description = "Time in seconds for the Auto Scaling Group to consider a new instance as fully working before counting it towards the desired capacity."
  type        = number
  default     = 300
}

variable "health_check_grace_period" {
  description = "Time in seconds for the Auto Scaling Group to wait before checking the health of a newly launched instance."
  type        = number
  default     = 300
}



