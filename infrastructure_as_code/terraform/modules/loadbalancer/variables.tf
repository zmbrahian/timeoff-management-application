variable "vpc_id" {
    type = string
    description = "ID of the VPC - Mandatory"
}

variable "public_subnet_id_a" {
    type = string
    description = "ID of the Public A subnet - Mandatory"
}

variable "public_subnet_id_b" {
    type = string
    description = "ID of the Public B subnet - Mandatory"
}

variable "private_subnet_id_a" {
    type = string
    description = "ID of the private A subnet - Mandatory"
}

variable "private_subnet_id_b" {
    type = string
    description = "ID of the private B subnet - Mandatory"
}

variable "aws_security_group_id" {
    type = string
    description = "ID of security group - Mandatory"
}
