locals {
  tags = merge(var.tags, { "k8s-cluster" = var.cluster_name })
}

resource "aws_key_pair" "key" {
  key_name   = "k8s-key"
  public_key = file(var.public_key_name)
  tags       = local.tags
}

resource "aws_eip" "master-eip" {
  domain = "vpc"
  tags   = local.tags
}

resource "aws_eip_association" "master-eip-associate" {
  allocation_id = aws_eip.master-eip.id
  instance_id   = aws_instance.master.id
}

resource "random_string" "token_id" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "token_secret" {
  length  = 16
  special = false
  upper   = false
}

locals {
  token = "${random_string.token_id.result}.${random_string.token_secret.result}"
}