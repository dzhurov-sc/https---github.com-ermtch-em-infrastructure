[
  {
    "name": "${container_name}",
    "image": "${container_image}",
    "cpu": 0,
    "links": [],
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port},
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "entryPoint": [],
    "command": [],
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "dev"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/${project_name}/${env}/${container_name}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
