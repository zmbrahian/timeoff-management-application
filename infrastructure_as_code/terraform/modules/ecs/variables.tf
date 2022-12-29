variable "aws_lb_target_group_arn" {
    type = string
    description = "ARN of aws lb target group - Mandatory"
}

variable "private_subnet_id_a" {
    type = string
    description = "ID of the Private A subnet - Mandatory"
}

variable "private_subnet_id_b" {
    type = string
    description = "ID of the Private B subnet - Mandatory"
}

variable "aws_security_group_id" {
    type = string
    description = "ID of security group - Mandatory"
}

variable "execution_role_arn" {
    type = string
    description = "ecsTaskExecutionRole ARN for ECS container permissions"
}

variable "docker_credential_secret_arn" {
    type = string
    description = "Secret arn that contains docker authentication"
}