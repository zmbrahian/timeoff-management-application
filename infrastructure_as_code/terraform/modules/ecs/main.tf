resource "aws_ecs_cluster" "prod_ecs_cluster" {
  name = "ProductionECS"
}

resource "aws_ecs_cluster_capacity_providers" "prod_cluster_capacity_provider" {
  cluster_name = aws_ecs_cluster.prod_ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "prod_timeoff_task_definition" {
  family = "prod_timeoff_webapp"
  network_mode = "awsvpc"
  execution_role_arn = var.execution_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu       = 256
  memory    = 512
  container_definitions = jsonencode([
    {
      name      = "timeoff-webapp-prod"
      image     = "zmbrahian/timeoff-webapp:latest"
      repositoryCredentials = {
        credentialsParameter = var.docker_credential_secret_arn
      }
      cpu       = 256
      memory    = 512
      essential = true
      entryPoint = ["npm", "start"]
      environment = [
        {
          name = "NODE_ENV"
          value = "production"
        } 
      ]
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      logConfiguration = {
          logDriver = "awslogs"
          options = {
              awslogs-group = "timeoff-webapp-prod"
              awslogs-region = "us-east-1"
              awslogs-create-group = "true"
              awslogs-stream-prefix = "timeoff-logs"
          }
      }    
    }
  ])
}

resource "aws_ecs_service" "prod_timeoff_service" {
  name            = "prod_timeoff_webapp"
  cluster         = aws_ecs_cluster.prod_ecs_cluster.id
  task_definition = aws_ecs_task_definition.prod_timeoff_task_definition.arn
  desired_count   = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200


  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = "timeoff-webapp-prod"
    container_port   = 3000
  }

  network_configuration {
    security_groups    = [var.aws_web_security_group_id]
    subnets            = [var.private_subnet_id_a, var.private_subnet_id_b]
  }
}