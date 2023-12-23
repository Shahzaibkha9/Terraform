variable "instance_name" {
  description = "Value of the Name tag for the EC2"
  type = string
  default = "test"
}

variable "instance-type" {
  description = "Value of the Instance type for the EC2"
  type = string
  default = "t3.micro"
}