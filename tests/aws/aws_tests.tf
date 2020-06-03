provider "aws" {
  region  = var.region
  version = ">=2.60"
  profile = var.awsProfile
}

provider "template" {
  version = ">= 2.1"
}

terraform {
  # backend "gcs" {
  #   bucket = "ds2"
  #   prefix = "terraform/tests/aws"
  #   # export GOOGLE_APPLICATION_CREDENTIALS=$HOME/my-credentials.json
  # }
  required_version = ">= 0.12"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Test Origin Identity"
}

module "role_test" {
  source           = "../../aws_iam_role"
  name             = "test-kms-users-role"
  policyData       = file("kms-users.json")
  useNameNotPrefix = true
}

module "kp_test" {
  source    = "../../aws_ssh_keypair"
  name      = "infra-test-keypair-20200202"
  publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQC2kV9nkyC4ZN4DF/Mo4PoIpoSBANPvdxxyq80hd5WtvpBJ+Y1fYNBiq60UD2oQbwC1w3+BFqJ8M7FK6MvbM13jxNtrbooKHad1nwdoJcB3226mhsarnVwbdQ4C+0SEhtdZQeAks28on1RqkaM23h5rUd966jF0eVmxYKWMRJk8J1Q3Cx5V4pMiIH7CpPzdPEmNYqjF7XZ/mKIkrIGTwWw+gd9938ZiQE7OT53vN3fQ8S3J6uF3KFwrBrrdRjX/ah5VUSXxsa1TBPf4Un98Hg1f1f56QOwcvFM/jNBhAdcQf6GOW2P0NHck3eGo2P6wnRtGfn6Bc7hCK6C0SJcchwzML6YoBd6++Rcjme8vxsT+fw7LXog3v9bcOzoHPHOFr7vnE7+8yf1cLzNC0g7t+6ZieqbvD2bB/uZ/vfCb1PMVegW20KWsN0TR4qCwMJUUUATI4XyLzJxF1WcxWx+z7hTm0K7ZZ7ncMDj9ywYTgFMFv9toK49OigSANzezYjP5eOpgAMs00qC9EICh3IyraSJZCuu2Bpjq1dVr6cnGCyT3bcp5k9KyiXDdBlndPlqK9+GzoygHcDdcks78eHxuV/t6XkGesYsy5ggzBDdPZO5//5eujkQozv6XCrVJcA01RnDBlUA0VoOTHfdGmsvSDL5C145BJMvyztfj9SKiD+8cZ03PVdLYEoDLmIYUHseiHytN43v2+m0ih7QnQCdkTUQeoN5882/HaPXrK2zW5C3FhY5kP69j4BvxdS03gTN6E1v7cJCHKlzyX7QYEAeyog0RRXU70YZrXxBIpPwt0A89kiR6apH8qUofwTfSNDH/qiUJkAOwBEPS2S1pKCIH2HZZDwtqreX56ya7YDV4W5icd3uE1mGaBLJ+A6jdDm0J4/szi3PUVdHAlM3sZR3SWfSJ5ARIqM7t4MifkZ+mqScQ7WhXf/rt29q5TSJtEi4M+i/RSMAc1PI4njUMfr2gisfmLyxfOL5v0sFL/q1ETmzkZn6wF6ps7O16zKVcSUBy5idMq4NMpRPUyOOEHBjxJsLtf2te17Uc0b+8ihJ8iSQi57uj3Nf5JVSP8pRrvYBzmE4TT96HuGbyhxyssSF5PXGIpxK5hLO7wD5M6b0DJO5TMobUPTkZj325q5hpXdOjjCXj8wXlYS+ZRvikMOZplxoi3Z1Cw4CBIvS56bnWWB9E50L2tkCosDQskX8Ozw7z5RJKRO3mOtKltOMBHdyGt7Suhw4if2whf2mA7jFcPKumDRTQnt2p7Ir0c1RCwe1iAhX7HXAx8dw/90TtztwBA2yZTTSOXOUBxQkeEoav273T8VQmtRIncyJfuJ8V+WfKzvNx/7lfPNW8IQrZ4u3HOCQ3 testkey"
}

module "user1" {
  source   = "../../aws_iam_user"
  username = "tim_test20200410"
  roleArns = [module.role_test.arn]
}

# module "aws_kms_test" {
#   source      = "../../aws_kms_key"
#   name        = "dirk testkey 1"
#   descr       = "a dummy test key"
#   aliasPrefix = "my-test-key"
# }

module "aws_kms_test2" {
  source  = "../../aws_kms_key"
  name    = "dirk-rds-key"
  descr   = "Key für RDS"
  keySpec = "SYMMETRIC_DEFAULT"
}

module "vpc_test" {
  source     = "../../aws_vpc_network"
  cidr       = "10.76.0.0/16"
  name       = "test vpc"
  availZones = var.avail_zones
  enableIpv6 = false
}

module "sns_test" {
  source = "../../aws_sns_topic"
  name   = "test-topic-1"
}

# module "es_test" {
#   source       = "../../aws_vpc_elasticsearch"
#   name         = "intra-test-es-20200102"
#   vpcId        = module.vpc_test.id
#   subnetGrpIds = [module.vpc_test.private_subnet_ids[0]]
#   # kmsKeyArn    = module.aws_kms_test2.arn
# }

# module "db_test" {
#   source             = "../../aws_db_encr"
#   name               = "db-test"
#   dbName             = "delmedb"
#   dbAdminUser        = "adm"
#   dbAdminPw          = "delmkmasdoiasdohidsaohasjladsnaldf"
#   kmsKeyArn          = module.aws_kms_test2.arn
#   subnetGrpIds       = module.vpc_test.private_subnet_ids
#   accessSubnetGrpIds = concat(module.vpc_test.private_subnet_ids, module.vpc_test.public_subnet_ids)
#   storageScaler      = 10
#   vpcId              = module.vpc_test.vpc_id
#   snsTopicArns       = [module.sns_test.arn]
# }

# module "aws_s3_test" {
#   source              = "../../aws_s3_bucket"
#   name                = "infra001-test-bucket-20200212"
#   readonlyIamArn      = [aws_cloudfront_origin_access_identity.oai.iam_arn]
#   adminIamArn         = [module.user1.arn]
#   versioned           = true
#   delCurrObjAfterDays = 360
# }

module "bastion" {
  source       = "../../aws_bastion"
  sshKeyName   = module.kp_test.name
  subnetId     = module.vpc_test.public_subnet_ids[0]
  kmsKeyArn    = module.aws_kms_test2.arn
  name         = "infra-bastion"
  snsTopicArns = [module.sns_test.arn]
}

# module "bastion2" {
#   source       = "../../aws_bastion"
#   sshKeyName   = module.kp_test.name
#   subnetId     = module.vpc_test.private_subnet_ids[0]
#   kmsKeyArn    = module.aws_kms_test2.arn
#   name         = "infra-bastion-2"
#   snsTopicArns = [module.sns_test.arn]
# }

module "aws_eks_test" {
  source       = "../../aws_eks_cluster"
  clusterName  = "infra-test-20200103"
  subnetIds    = module.vpc_test.private_subnet_ids
  sshKeyName   = module.kp_test.name
  snsTopicArns = [module.sns_test.arn]
  vpcId        = module.vpc_test.id
  kmsKeyArn    = module.aws_kms_test2.arn
  clusterSize  = 1
}
