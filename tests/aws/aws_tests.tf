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
#   dbParams = {
#     "rds.logical_replication" = "1"
#   }
# }

# module "aws_s3_test" {
#   source              = "../../aws_s3_bucket"
#   name                = "infra001-test-bucket-20200212"
#   readonlyIamArn      = [aws_cloudfront_origin_access_identity.oai.iam_arn]
#   adminIamArn         = [module.user1.arn]
#   versioned           = true
#   delCurrObjAfterDays = 360
# }
