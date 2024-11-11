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
    "mountPoints": [
      %{ for k, v in volumes ~}
      {
        "sourceVolume": "${k}",
        "containerPath": "${v.container_path}",
        "readOnly": false
      }
      %{ endfor ~}
    ],
    "volumesFrom": [],
    "logConfiguration": {
      "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/${project_name}/${env}/${container_name}",
          "awslogs-region": "us-east-2",
          "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
