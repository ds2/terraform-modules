{
    "rulePriority": 2,
    "description": "Keep last tagged images",
    "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ${PREFIXES},
        "countType": "imageCountMoreThan",
        "countNumber": ${NUM_COUNT}
    },
    "action": {
        "type": "expire"
    }
}
