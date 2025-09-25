output "k8s-master-eip-IP" {
  value = aws_eip.master-eip.public_ip
}

output "worker_private_ips" {
  value = aws_instance.worker[*].private_ip
}