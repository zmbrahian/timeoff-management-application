variable "private_subnet_id_a" {
    type = string
    description = "ID of the Private A subnet - Mandatory"
}

variable "private_subnet_id_b" {
    type = string
    description = "ID of the Private B subnet - Mandatory"
}

variable "mysql_database_name" {
    type = string
    description = "Name of database"
}

variable "mysql_database_username" {
    type = string
    description = "Username to be created for mysql connections"
}

variable "mysql_database_password" {
    type = string
    description = "Password to be created for mysql connections"
}

variable "aws_mysql_security_group_id" {
    type = string
    description = "Security group for mysql connections"
}