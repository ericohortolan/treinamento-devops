provider "aws" {
  region = "sa-east-1"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
}

resource "aws_instance" "jenkins2" {
  ami                         = "ami-054a31f1b3bf90920"
  instance_type               = "t2.large"
  subnet_id                   = "subnet-0cde2b21259997493"
  associate_public_ip_address = true
  key_name                    = "erico-keypar"
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "Erico-jenkins"
  }
  vpc_security_group_ids = ["${aws_security_group.jenkins2.id}"]
}

resource "aws_security_group" "jenkins2" {
  vpc_id      = "vpc-0530e1ffb643de5d0"
  name        = "Erico-acessos_jenkins"
  description = "acessos_jenkins inbound traffic"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    {
      description      = "SSH from VPC"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "Erico-SG-jenkins-lab"
  }
}

# terraform refresh para mostrar o ssh
output "jenkins" {
  value = [
    "jenkins",
    "id: ${aws_instance.jenkins2.id}",
    "private: ${aws_instance.jenkins2.private_ip}",
    "public: ${aws_instance.jenkins2.public_ip}",
    "public_dns: ${aws_instance.jenkins2.public_dns}",
    "ssh -i ~/Desktop/devops/treinamentoItau ubuntu@${aws_instance.jenkins2.public_dns}"
  ]
}
