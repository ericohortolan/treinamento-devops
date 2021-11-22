provider "aws" {
  region = "sa-east-1"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
}

resource "aws_instance" "maquina_master" {
  subnet_id     = "${var.subnet_id}"
  ami           = "${var.image_id}"
  instance_type = "t2.large"
  key_name = "erico-keypar"
  associate_public_ip_address = true
  tags = {
    Name = "Erico-k8s-master"
  }
  vpc_security_group_ids = ["${aws_security_group.allow_eks_master.id}"]
  #vpc_security_group_ids = [aws_security_group.acessos_master_single_master.id]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
}

resource "aws_instance" "workers" {
  subnet_id     = "${var.subnet_id}"
  ami           = "${var.image_id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  tags = {
    Name = "Erico-k8s-node-${count.index}"
  }
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  key_name = "erico-keypar"
  vpc_security_group_ids = ["${aws_security_group.allow_eks_workers.id}"]
  count         = 3
}

resource "aws_security_group" "allow_eks_master" {
  name        = "Erico-allow_eks_master"
  description = "acessos_workers_single_master inbound traffic"
  vpc_id      = "${var.aws_vpc_id}"
  ingress = [
    {
      description      = "SSH from any"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = [
        "${aws_security_group.allow_eks_workers.id}",
      ]
      self             = false
      to_port          = 0
    },
    {
      description      = "porta30001"
      from_port        = 30001
      to_port          = 30001
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    },
    {
      description      = "porta30002"
      from_port        = 30002
      to_port          = 30002
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "Erico-SG-allow_eks_master"
  }
}


resource "aws_security_group" "allow_eks_workers" {
  name        = "Erico-allow_eks_workers"
  description = "acessos_workers_single_master inbound traffic"
  vpc_id      = "${var.aws_vpc_id}"
  ingress = [
    {
      description      = "SSH from any"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    },
    #{
    #  cidr_blocks      = []
    #  description      = ""
    #  from_port        = 0
    #  ipv6_cidr_blocks = []
    #  prefix_list_ids  = []
    #  protocol         = "-1"
    #  security_groups  = [
    #    "${aws_security_group.allow_eks_master.id}",
    #  ]
    #  self             = false
    #  to_port          = 0
    #}
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "Erico-allow_eks_workers"
  }
}

# this rule depends on both security groups so separating it allows it
# to be created after both
resource "aws_security_group_rule" "extra_rule" {
  security_group_id        = "${aws_security_group.allow_eks_workers.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.allow_eks_master.id}"
}




# terraform refresh para mostrar o ssh
output "maquina_master" {
  value = [
    "master - ${aws_instance.maquina_master.public_ip} - ssh -i ~/Desktop/devops/treinamentoItau ubuntu@${aws_instance.maquina_master.public_dns}"
  ]
}

# terraform refresh para mostrar o ssh
output "aws_instance_e_ssh" {
  value = [
    for key, item in aws_instance.workers :
      "worker ${key+1} - ${item.public_ip} - ssh -i ~/Desktop/devops/treinamentoItau ubuntu@${item.public_dns}"
  ]
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