provider "aws" {
  region  = var.region
  version = ">=2.44.0"
  profile = var.awsProfile
}

provider "template" {
  version = ">= 2.1.2"
}

terraform {
  backend "gcs" {
    bucket = "ds2"
    prefix = "terraform/tests/aws"
    # export GOOGLE_APPLICATION_CREDENTIALS=$HOME/my-credentials.json
  }
  required_version = ">= 0.12"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Test Origin Identity"
}

module "role_test" {
  source     = "../../modules/aws_iam_role"
  roleName   = "kms-users"
  policyData = file("kms-users.json")
}

module "user1" {
  source   = "../../modules/aws_iam_user"
  username = "tim"
  roleArns = [module.role_test.arn]
}

# module "aws_kms_test" {
#   source      = "../../modules/aws_kms_key"
#   name        = "dirk testkey 1"
#   descr       = "a dummy test key"
#   aliasPrefix = "my-test-key"
# }

# module "aws_kms_test2" {
#   source      = "../../modules/aws_kms_key"
#   name        = "dirk rds key"
#   descr       = "Key für RDS"
#   aliasPrefix = "dirk-rds-key"
#   keySpec="SYMMETRIC_DEFAULT"
# }

# module "vpc_test" {
#   source = "../../modules/aws_vpc_network"
#   cidr   = "10.76.0.0/16"
#   # privateSubnetCidr = "10.76.1.0/24"
#   # publicSubnetCidr  = "10.76.2.0/24"
#   name       = "test vpc"
#   availZones = var.avail_zones
# }

# module "db_test" {
#   source        = "../../modules/aws_db_encr"
#   name          = "dbtest"
#   dbAdminUser   = "adm"
#   dbAdminPw     = "delmkmasdoiasdohidsaohasjladsnaldf"
#   kmsKeyArn     = module.aws_kms_test2.arn
#   subnetGrpIds  = module.vpc_test.private_subnet_ids
#   storageScaler = 10
#   vpcId         = module.vpc_test.vpc_id
# }

# module "aws_s3_test" {
#   source         = "../../modules/aws_s3_bucket"
#   name           = "infra001-test-bucket-20200212"
#   readonlyIamArn = [aws_cloudfront_origin_access_identity.oai.iam_arn]
#   adminIamArn    = [module.user1.arn]
#   versioned      = true
# }
