module "vpc" {
    source = "../../modules/vpc"  
}

module "loadbalancer" {
    source = "../../modules/loadbalancer"
    vpc_id = module.vpc.vpc_id
    public_subnet_id_a = module.vpc.public_subnet_id_a
    public_subnet_id_b = module.vpc.public_subnet_id_b
    private_subnet_id_a = module.vpc.private_subnet_id_a
    private_subnet_id_b = module.vpc.private_subnet_id_b
    aws_security_group_id = module.vpc.aws_security_group_id
    certificate_arn = var.certificate_arn
}

module "ecs" {
    source = "../../modules/ecs"
    aws_lb_target_group_arn = module.loadbalancer.aws_lb_target_group_arn
    private_subnet_id_a = module.vpc.private_subnet_id_a
    private_subnet_id_b = module.vpc.private_subnet_id_b
    aws_security_group_id = module.vpc.aws_security_group_id
    execution_role_arn = var.execution_role_arn
    docker_credential_secret_arn = var.docker_credential_secret_arn
}

variable "execution_role_arn" {
    type = string
    description = "ecsTaskExecutionRole ARN for ECS container permissions"
}

variable "docker_credential_secret_arn" {
    type = string
    description = "Secret arn that contains docker authentication"
}

variable "certificate_arn" {
    type = string
    description = "ACM certificate arn for HTTPS listener"
}
