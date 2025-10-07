variable "name" {
  description = "Name of instance"
  default = "AUto"
  type=string
}

variable "instance_type" {
  default = "t2.micro"
  description = "Instance type"
  type=string
}