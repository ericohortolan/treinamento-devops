terraform {
  required_version = ">= 0.12" # colocando compatibilidade do terraform para 0.12
}

resource "aws_instance" "web" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "${var.instanceType}"
  key_name                = "erico-keypar" # key chave publica cadastrada na AWS 
  subnet_id               = "${var.SubnetId}"
  associate_public_ip_address = true
  vpc_security_group_ids  = [
    "sg-0ed15f7d24a2bd382",
  ]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apache2 -y
  sudo systemctl enable apache2
  sudo systemctl start apache2
  EOF
  tags = {
    Name = "Erico-TF-Module-${var.Nome}"
  }
}


variable "Nome" {
  type = string
  description = "Digite o nome da instancia"
}

variable "SubnetId" {
  type = string
  description = "SubnetId"
}

variable "instanceType" {
  type = string
  description = "instanceType"
}

