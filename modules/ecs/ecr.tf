##############################
# Elastic Container Registry #
##############################

resource "aws_ecr_repository" "repository" {

  for_each = local.services_definition

  name                 = each.key
  image_tag_mutability = "MUTABLE"

  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "services_autodelete" {
  for_each   = local.services_definition
  repository = each.key

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Delete images older than 30 days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
