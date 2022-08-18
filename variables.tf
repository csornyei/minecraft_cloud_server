variable "sec_group_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "route53_zone_name" {
  type    = string
  default = "csornyei.com"
}

variable "url" {
  type    = string
  default = "minecraft.csornyei.com"
}
