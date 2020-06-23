{
    "rulePriority": 1,
    "description": "Expire untagged images",
    "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${NUM_DAYS}
    },
    "action": {
        "type": "expire"
    }
}
