variable "username" {
    type=string
}

variable "roleArns" {
    type=set(string)
    default=[]
}

variable "awsPath" {
    type=string
    default="/"
}
