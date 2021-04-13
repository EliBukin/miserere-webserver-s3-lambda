variable "ami" {
  default = "ami-0b7fd7bc9c6fb1c78"
}

variable "vm_size" {
  default = "t2.micro"
}

variable "keyname" {
  default = "ssb"
}

variable "aws_private_key_location" {
  default = "/home/barracuda/Desktop/work/ssb.pem"
}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "elb_port" {
  description = "The port the ELB will use for HTTP requests"
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "The port the SSH will use for SSH requests"
  type        = number
  default     = 22
}
