variable "region" {
  description = "This will be the region"
  type        = string
}

variable "vpc_cidr" {
  description = "This will be your CIDR range"
  type        = string
}

variable "subnet_cidr" {
  description = "This will be your subnet"
  type        = string
}

variable "public_key_name" {
  description = "This will be your key location"
  type        = string
}

variable "private_key_name" {
  description = "This will be the private key location"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "A set of tags to assign to the created AWS resources"
}

variable "volume_size" {
  description = "This will be the disk volume"
  type        = number
}

variable "master_instance_type" {
  description = "value"
  type        = string
}

variable "worker_instance_type" {
  description = "value"
  type        = string
}

variable "worker_count" {
  description = "This will be your number of worker instance"
  type        = number
}

variable "cluster_name" {
  description = "Name of the k8s cluster"
  type        = string
}

variable "allowed_k8s_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make Kubernetes API request"
}

variable "allowed_ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make SSH connections to the EC2 instances"
}

variable "pod_network_cidr_block" {
  type        = string
  description = "CIDR block for the Pod network of the cluster"
}