variable "username" {
    type=string
}

variable "policyArns" {
    type=set(string)
    default=[]
}

variable "awsPath" {
    type=string
    default="/"
}
