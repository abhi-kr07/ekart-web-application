###### Fetching Latest AMI #########

data "aws_ami" "ubuntu" {

  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]

}

######## AWS Key-Pair #########


resource "aws_key_pair" "ekart-key" {
  key_name   = "aws-key"
  public_key = file(var.key-name)
}

####### Security group for servers ###########

resource "aws_security_group" "servers-sg" {
  name        = "servers-securityGroup"
  description = "To handle inbound and outbound for the servers like jenkins, sonarqube and nexus"

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 443
    from_port   = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 25
    from_port   = 25
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 465
    from_port   = 465
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 10000
    from_port   = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

