# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_instance" "web" {
#   ami           = "ami-09e67e426f25ce0d7"
#   instance_type = "t2.micro"
#   subnet_id              = "subnet-eddcdzz4"
#   # availability_zones = ["us-east-1"] # configurando zona para criar maquinas
#   tags = {
#     Name = "Minha Maquina Simples EC2"
#   }
#   volume_id = aws_ebs_volume.itau_volume_encrypted.id
# }


# resource "aws_ebs_volume" "itau_volume_encrypted" {
#   size      = 8
#   encrypted = true
#   tags      = {
#     Name = "Volume itaú"
#   }
# }



##### Caso Itaú #####
# aws configure # maquina pessoal
# nas do itaú colocar as variáveis de ambiente no bashrc
# https://docs.aws.amazon.com/sdkref/latest/guide/environment-variables.html
# configurar via environment variable
# export AWS_ACCESS_KEY_ID=""
# export AWS_SECRET_ACCESS_KEY=""
# export AWS_DEFAULT_REGION=""

# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_instance" "web" {
#   ami = "ami-09e67e426f25ce0d7"
#   instance_type = "t3.micro"
#   subnet_id = "subnet-05880ea9006199004"
  
#   tags = {
#     Name = "MinhaPrimeiraMaquina-Carol  "
#   }
# }

# resource "aws_ebs_volume" "itau_volume_encrypted" {
#   size      = 8
#   encrypted = true
#   availability_zone = "us-east-1a"
#   tags      = {
#     Name = "Volume itaú"
#   }
# }

# resource "aws_volume_attachment" "ebs_att" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.itau_volume_encrypted.id
#   instance_id = aws_instance.web.id
# }

# Gamaacademythree-sbx - # passago a chave pelo pessoal de segurança itaú
# export AWS_ACCESS_KEY_ID="3232323232"
# export AWS_SECRET_ACCESS_KEY="34433444sssdd3+ssa/dd434343"

# //////

# ///////// do fernando zerati //////
provider "aws" {
  region = "sa-east-1"
}
resource "aws_instance" "web" {
  subnet_id     = "${var.subnet_id}"
  ami= "${var.image_id}"
  instance_type = "t2.small"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${var.securitygroup_id}"]
  key_name = "erico-keypar"
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "Erico-EC21-tf"
  }
}



# https://www.terraform.io/docs/language/values/outputs.html
output "instance_public_dns" {
  value = [aws_instance.web.public_dns,aws_instance.web.public_ip, aws_instance.web.private_ip]
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

variable "securitygroup_id" {
  type        = string
  description = "Digite o id do Security Group para ser usado:"

  validation {
    condition     = length(var.securitygroup_id) > 3 && substr(var.securitygroup_id, 0, 3) == "sg-"
    error_message = "O valor do SG não é válido, tem que começar com \"sg-\"."
  }
}

variable "subnet_id" {
  type        = string
  description = "Digite o id da subnet para ser usado:"

  validation {
    condition     = length(var.subnet_id) > 7 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "O valor da Subnet não é válido, tem que começar com \"subnet-\"."
  }
}

# /////