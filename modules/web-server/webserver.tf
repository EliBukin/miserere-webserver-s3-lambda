
data "aws_availability_zones" "all" {}


# CREATE THE AUTO SCALING GROUP
resource "aws_autoscaling_group" "sini_asg" {
  launch_configuration = aws_launch_configuration.sini_launch_configuration.id
  availability_zones   = data.aws_availability_zones.all.names

  min_size = 1
  max_size = 10

  load_balancers    = [aws_elb.sini_elb.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-miserere-asg"
    propagate_at_launch = true
  }
}


# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE ASG
resource "aws_launch_configuration" "sini_launch_configuration" {
  # Ubuntu Server
  key_name        = var.keyname
  image_id        = var.ami
  instance_type   = var.vm_size
  security_groups = [aws_security_group.sini_security_group.id]
  user_data       = file("modules/web-server/echo-httpd-03.sh")

  # Whenever using a launch configuration with an auto scaling group, you must set create_before_destroy = true.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}


# CREATE THE SECURITY GROUP THAT'S APPLIED TO EACH EC2 INSTANCE IN THE ASG
resource "aws_security_group" "sini_security_group" {
  name = "terraform-miserere-securitygroup-ec2"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound SSH from anywhere
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# CREATE AN ELB TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
resource "aws_elb" "sini_elb" {
  name               = "terraform-miserere-elb"
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}


# CREATE A SECURITY GROUP THAT CONTROLS WHAT TRAFFIC AN GO IN AND OUT OF THE ELB
resource "aws_security_group" "elb" {
  name = "terraform-miserere-securitygroup-elb"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
