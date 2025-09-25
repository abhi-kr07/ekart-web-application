######### sonarqube server ###########

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.ekart-key.key_name
  vpc_security_group_ids = [aws_security_group.servers-sg.id]
  instance_type          = var.instance_type
  user_data              = base64encode(file("scripts/sonarqube.sh"))

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp2"
  }

  tags = {
    "Name" = "Sonarqube-Server"
  }

}