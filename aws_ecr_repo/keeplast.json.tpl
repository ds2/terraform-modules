{
    "rulePriority": 2,
    "description": "Keep last tagged images",
    "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v","test","really"],
        "countType": "imageCountMoreThan",
        "countNumber": ${NUM_COUNT}
    },
    "action": {
        "type": "expire"
    }
}