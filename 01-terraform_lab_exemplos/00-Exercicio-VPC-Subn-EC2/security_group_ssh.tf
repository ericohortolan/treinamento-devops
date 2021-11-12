# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest/submodules/ssh#input_auto_computed_egress_rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

# ingress = [  # inbound
# egress = [ # outbound

resource "aws_security_group" "allow_http_ssh" {
  name        = "erico_allow_http_ssh"
  description = "Allow SSH inbound traffic"
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
      description      = "HTTP from any"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    },
    {
      description      = "ICMP from any"
      from_port        = "0"
      to_port          = "0"
      protocol         = "icmp"
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
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null,
      description      = "Libera saida"
    }
  ]

  tags = {
    Name = "Erico-allow_ssh-TF"
  }

}