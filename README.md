# DS/2 Terraform Modules

[![pipeline status](https://gitlab.com/ds_2/terraform-modules/badges/develop/pipeline.svg)](https://gitlab.com/ds_2/terraform-modules/-/commits/develop)

Some terraform modules.

## Import

In your tf file, create a new module and reference this repository:

    module "aws1" {
        source = "git::https://gitlab.com/ds_2/terraform-modules.git//aws_s3_bucket?ref=v0.1.2"
        name   = "my-bucket"
    }

The ref parameter defines the tag name to checkout. You should update it to the latest stable version. If omitted, you usually get the master branch content which may change over time (which is not good for YOUR recipes!!).

## Release

Simply apply a tag in the format "vMYVERSION". Semantic versioning.
You can do so by running:

    # please update the release tag here!!
    MYTAG="v0.3.10"
    git tag -s ${MYTAG} && git tag -v ${MYTAG} -m "Releasing version ${MYTAG}" && git push origin ${MYTAG}
