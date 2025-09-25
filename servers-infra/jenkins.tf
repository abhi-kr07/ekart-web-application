####### jenkins server #########

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.ekart-key.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.servers-sg.id]
  user_data              = base64encode(file("scripts/jenkins.sh"))

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp2"
  }

  tags = {
    "Name" = "Jenkins-Server"
  }

}