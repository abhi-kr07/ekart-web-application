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

resource "aws_instance" "master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.master_instance_type
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.egress.id, aws_security_group.ingress_internal.id, aws_security_group.k8s-ingress.id, aws_security_group.SSH.id]
  key_name               = aws_key_pair.key.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  tags = {
    "Name" = "k8s-master"
  }

  user_data = templatefile("./scripts/kubeadm.tftpl", {
    node              = "master",
    token             = local.token,
    cidr              = null,
    master_public_ip  = aws_eip.master-eip.public_ip,
    master_private_ip = null,
    worker_index      = null

  })
}

resource "aws_instance" "worker" {
  count                       = var.worker_count
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.egress.id, aws_security_group.ingress_internal.id, aws_security_group.k8s-ingress.id, aws_security_group.SSH.id]
  instance_type               = var.worker_instance_type
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  tags = {
    "Name" = "k8s-minion-${count.index}"
  }

  user_data = templatefile("./scripts/kubeadm.tftpl", {
    node              = "worker",
    token             = local.token,
    cidr              = null,
    master_public_ip  = null,
    master_private_ip = aws_instance.master.private_ip,
    worker_index      = count.index
  })
}

resource "null_resource" "master_bootstrap" {
  depends_on = [aws_instance.master]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_name)
    host        = aws_eip.master-eip.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /home/ubuntu/done ]; do",
      "  echo 'Waiting for bootstrap completion in the Master'",
      "  sleep 5",
      "done",
      "echo 'Bootstrap completed in the Master'"
    ]
  }

  triggers = {
    instance_ids = join(",", concat([aws_instance.master.id], aws_instance.worker[*].id))
  }
}

