resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr
  tags              = local.tags
  availability_zone = "ap-south-1a"
  # map_public_ip_on_launch = true (As we will assign Elastic IP) 

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = local.tags
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = local.tags
}

resource "aws_route_table_association" "rta" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_security_group" "egress" {
  name        = "${var.cluster_name}-egress"
  description = "This will allow network traffic to go everywhere"
  vpc_id      = aws_vpc.my_vpc.id
  tags        = local.tags
  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_internal" {
  name        = "${var.cluster_name}-ingress-internal"
  description = "This provide node to node and pod to pod network traffic in the cluster"
  vpc_id      = aws_vpc.my_vpc.id
  tags        = local.tags
  ingress {
    to_port   = 0
    from_port = 0
    protocol  = -1
    self      = true
  }

  ingress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = var.pod_network_cidr_block != null ? [var.pod_network_cidr_block] : null
  }
}

resource "aws_security_group" "k8s-ingress" {
  name        = "${var.cluster_name}-k8s-ingress"
  description = "Allow incoming Kubernetes API requests (TCP/6443) from outside the cluster"
  vpc_id      = aws_vpc.my_vpc.id
  tags        = local.tags
  ingress {
    to_port     = 6443
    from_port   = 6443
    protocol    = "TCP"
    cidr_blocks = var.allowed_k8s_cidr_blocks
  }
}

resource "aws_security_group" "SSH" {
  name        = "${var.cluster_name}-SSH-sg"
  description = "Allow SSH traffic from outside the cluster"
  vpc_id      = aws_vpc.my_vpc.id
  tags        = local.tags
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "TCP"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }
}
