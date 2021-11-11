#resource "aws_vpc" "my_vpc" {
#  cidr_block = "10.99.0.0/16"
#  enable_dns_support = true
#  enable_dns_hostnames = true
#
#  tags = {
#    Name = "vpc-erico"
#  }
#  lifecycle {
#    prevent_destroy = true
#  }
#}

resource "aws_subnet" "my_subnet_1a" {
  vpc_id            = "${var.aws_vpc_id}"
  cidr_block        = "10.99.10.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "Erico-TF-SubnetPub-Pub-1a"
  }
}

resource "aws_subnet" "my_subnet_1b" {
  vpc_id            = "${var.aws_vpc_id}"
  cidr_block        = "10.99.11.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "Erico-TF-SubnetPub-1b"
  }
}

resource "aws_subnet" "my_subnet_1c" {
  vpc_id            = "${var.aws_vpc_id}"
  cidr_block        = "10.99.12.0/24"
  availability_zone = "sa-east-1c"

  tags = {
    Name = "Erico-TF-SubnetPub-1c"
  }
}

resource "aws_subnet" "my_subnetPriv_1a" {
  vpc_id            = "${var.aws_vpc_id}"
  cidr_block        = "10.99.13.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "Erico-TF-SubnetPriv-1a"
  }
}

#resource "aws_internet_gateway" "gw" {
#  vpc_id = "vpc-0530e1ffb643de5d0"
#  tags = {
#    Name = "vpc-erico"
#  }
#  lifecycle {
#    prevent_destroy = true
#  }
#}

resource "aws_route_table" "rtPub_terraform" {
  vpc_id = "vpc-0530e1ffb643de5d0"

  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = "igw-0644fd1043ba5793b"
        instance_id                = ""
        ipv6_cidr_block            = ""
        local_gateway_id           = ""
        nat_gateway_id             = ""
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]

  tags = {
    Name = "Erico-TF-PublicRT"
  }
}

resource "aws_route_table" "rtPriv_terraform" {
  vpc_id = "${var.aws_vpc_id}"
  tags = {
    Name = "Erico-TF-PrivateRT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet_1a.id
  route_table_id = aws_route_table.rtPub_terraform.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.my_subnet_1b.id
  route_table_id = aws_route_table.rtPub_terraform.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.my_subnet_1c.id
  route_table_id = aws_route_table.rtPub_terraform.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.my_subnetPriv_1a.id
  route_table_id = aws_route_table.rtPriv_terraform.id
}


# resource "aws_network_interface" "my_subnet" {
#   subnet_id           = aws_subnet.my_subnet.id
#   private_ips         = ["172.17.10.100"] # IP definido para instancia
#   # security_groups = ["${aws_security_group.allow_ssh1.id}"]

#   tags = {
#     Name = "primary_network_interface my_subnet"
#   }
# }