variable "name" {
    type=string
}

variable "tagMutable" {
    type=bool
    default=true
}

variable "deleteUntaggedAfterDays" {
    type=number
    default=14
}

variable "keepTagsCount" {
    type=number
    default=30
}
