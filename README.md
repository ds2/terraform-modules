# DS/2 Terraform Modules

[![pipeline status](https://gitlab.com/ds_2/terraform-modules/badges/develop/pipeline.svg)](https://gitlab.com/ds_2/terraform-modules/-/commits/develop)

Some terraform modules.

## Import

In your tf file, create a new module and reference this repository:

    module "aws1" {
        source = "git::git@gitlab.com:ds_2/terraform-modules.git//aws_s3_bucket"
        name   = "my-bucket"
    }

If a specific version/tag is required, use

    ?ref=v1.2.0

in the source url
