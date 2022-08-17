output "instance_elastic_ip" {
  value = aws_eip.ip_minecraft.public_ip
}
