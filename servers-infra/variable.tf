variable "region" {
  description = "This will be your region"
  type        = string
}

variable "disk_size" {
  description = "This will be your volume size of the servers"
  type        = number
}

variable "key-name" {
  description = "This will be the location of the key-pair"
  type        = string
}

variable "instance_type" {
  description = "This is the type of instance"
  type        = string

}