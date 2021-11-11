provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "web1a" {
  subnet_id     = "${aws_subnet.my_subnet_1a.id}"
  ami= "${var.image_id}"
  instance_type = "t3.small"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.allow_http_ssh.id}"]
  key_name = "erico-keypar"
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
    Name = "Erico-TF-EC2-1a"
  }
}


resource "aws_instance" "web1b" {
  subnet_id     = "${aws_subnet.my_subnet_1b.id}"
  ami= "${var.image_id}"
  instance_type = "t3.small"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.allow_http_ssh.id}"]
  key_name = "erico-keypar"
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
    Name = "Erico-TF-EC2-1b"
  }
}


resource "aws_instance" "web1c" {
  subnet_id     = "${aws_subnet.my_subnet_1c.id}"
  ami= "${var.image_id}"
  instance_type = "t3.small"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.allow_http_ssh.id}"]
  key_name = "erico-keypar"
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
    Name = "Erico-TF-EC2-1b"
  }
}


resource "aws_instance" "priv1a" {
  subnet_id     = "${aws_subnet.my_subnetPriv_1a.id}"
  ami= "${var.image_id}"
  instance_type = "t3.small"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.allow_http_ssh.id}"]
  key_name = "erico-keypar"
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
    Name = "Erico-TF-EC2-1b"
  }
}

output "instanceweb1a_public_dns" {
  value = [aws_instance.web1a.public_dns,aws_instance.web1a.public_ip, aws_instance.web1a.private_ip]
  description = "Mostra o DNS e os IPs publicos e privados da maquina criada."
}

output "instanceweb1b_public_dns" {
  value = [aws_instance.web1b.public_dns,aws_instance.web1b.public_ip, aws_instance.web1b.private_ip]
  description = "Mostra o DNS e os IPs publicos e privados da maquina criada."
}

output "instanceweb1c_public_dns" {
  value = [aws_instance.web1c.public_dns,aws_instance.web1c.public_ip, aws_instance.web1c.private_ip]
  description = "Mostra o DNS e os IPs publicos e privados da maquina criada."
}

output "instancepriv1a_public_dns" {
  value = [aws_instance.priv1a.public_dns,aws_instance.priv1a.public_ip, aws_instance.priv1a.private_ip]
  description = "Mostra o DNS e os IPs publicos e privados da maquina criada."
}

variable "image_id" {
  type        = string
  description = "Digite o id do AMI para ser usado:"

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "O valor do image_id não é válido, tem que começar com \"ami-\"."
  }
}

locals {
  data = timestamp()
}

variable "subnet_id" {
  type        = string
  description = "Digite o id da subnet para ser usado:"

  validation {
    condition     = length(var.subnet_id) > 7 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "O valor da Subnet não é válido, tem que começar com \"subnet-\"."
  }
}


variable "aws_vpc_id" {
  type        = string
}