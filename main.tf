resource "aws_vpc" "minecraft_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "minecraft-vpc"
  }
}

resource "aws_subnet" "minecraft_public_subnet" {
  vpc_id                  = aws_vpc.minecraft_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    "Name" = "minecraft-public"
  }
}

resource "aws_internet_gateway" "minecraft_internet_gateway" {
  vpc_id = aws_vpc.minecraft_vpc.id

  tags = {
    "Name" = "minecraft-internet_gateway"
  }
}

resource "aws_route_table" "minecraft_route_table" {
  vpc_id = aws_vpc.minecraft_vpc.id

  tags = {
    "Name" = "minecraft-route-table"
  }
}

resource "aws_route" "minecraft_default_route" {
  route_table_id         = aws_route_table.minecraft_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.minecraft_internet_gateway.id
}

resource "aws_route_table_association" "minecraft_public_assoc" {
  subnet_id      = aws_subnet.minecraft_public_subnet.id
  route_table_id = aws_route_table.minecraft_route_table.id
}

resource "aws_key_pair" "minecraft_auth" {
  key_name   = "minecraft_ssh_key"
  public_key = file("/Users/matecsornyei/.ssh/aws_dev_env_key.pub")
}

resource "aws_spot_instance_request" "minecraft_node_request" {
  ami                  = data.aws_ami.server_ami.id
  spot_price           = "0.05"
  instance_type        = "t3.medium"
  spot_type            = "one-time"
  wait_for_fulfillment = true
  key_name             = aws_key_pair.minecraft_auth.key_name
  vpc_security_group_ids = [
    aws_security_group.minecraft_ingress_ssh_sec_group.id,
    aws_security_group.minecraft_ingress_mc_server_sec_group.id
  ]
  subnet_id = aws_subnet.minecraft_public_subnet.id

  tags = {
    "Name" = "minecraft-node"
  }
}

resource "aws_eip" "ip_minecraft" {
  instance = aws_spot_instance_request.minecraft_node_request.spot_instance_id
  vpc      = true

  provisioner "local-exec" {
    command = templatefile("ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu"
      identityFile = "~/.ssh/aws_dev_env_key"
    })
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command = templatefile("update_ansible_hosts.tpl", {
      ip_address = self.public_ip,
    })
    interpreter = ["bash", "-c"]
  }
}
