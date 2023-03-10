# Define an ECR repository
resource "aws_ecr_repository" "ecr" {
  name = local.ecr_name

  tags = {
    Name = local.ecr_name
  }
}

# Define an ECS cluster
resource "aws_ecs_cluster" "ecs" {
  name = local.ecs_cluster_name

  tags = {
    Name = local.ecs_cluster_name
  }
}

# Define ECS cluster capacity providers
resource "aws_ecs_cluster_capacity_providers" "ecs" {
  cluster_name       = aws_ecs_cluster.ecs.name
  capacity_providers = var.ecs_providers_list
}

# Define an ECS task definition
resource "aws_ecs_task_definition" "ecs" {
  family       = local.ecs_task_family
  memory       = var.ecs_task_memory
  network_mode = "awsvpc"

  container_definitions = jsonencode([
    {
      name  = "${aws_ecs_cluster.ecs.name}"
      image = "${aws_ecr_repository.ecr.repository_url}:latest"
      portMappings = [
        {
          containerPort = "${var.ecs_service_container_port}"
        }
      ]
    }
  ])

  tags = {
    Name = local.ecs_task_family
  }
}

# Define an ECS Service
resource "aws_ecs_service" "ecs" {
  name            = local.ecs_service_name
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs.arn

  network_configuration {
    subnets = [aws_subnet.priv_a.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = aws_ecs_cluster.ecs.name
    container_port   = var.ecs_service_container_port
  }

  tags = {
    Name = local.ecs_service_name
  }
}
