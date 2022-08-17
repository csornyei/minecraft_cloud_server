resource "aws_security_group" "minecraft_ingress_ssh_sec_group" {
  name        = "minecraft_ingress_ssh_sec_group"
  description = "Security group to ssh into minecraft server"
  vpc_id      = aws_vpc.minecraft_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sec_group_cidr_block]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "minecraft_ingress_http_sec_group" {
  name        = "minecraft_ingress_http_sec_group"
  description = "Security group to allow http on minecraft server"
  vpc_id      = aws_vpc.minecraft_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.sec_group_cidr_block]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "minecraft_ingress_mc_server_sec_group" {
  name        = "minecraft_ingress_mc_server_sec_group"
  description = "Security group to allow connecting to the minecraft server"
  vpc_id      = aws_vpc.minecraft_vpc.id

  ingress {
    cidr_blocks = [var.sec_group_cidr_block]
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

