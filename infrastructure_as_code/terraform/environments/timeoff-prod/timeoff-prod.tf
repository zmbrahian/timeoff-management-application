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
}

module "ecs" {
    source = "../../modules/ecs"
    aws_lb_target_group_arn = module.loadbalancer.aws_lb_target_group_arn
    private_subnet_id_a = module.vpc.private_subnet_id_a
    private_subnet_id_b = module.vpc.private_subnet_id_b
    aws_security_group_id = module.vpc.aws_security_group_id
}