# Changelog

All notable changes to this project will be documented in this file.

## [0.7.0] - 2025-05-26

### 📚 Documentation

- Update module docs

### ⚙️ Miscellaneous Tasks

- Update gitlab test to use Gitlab provider v17
- Require Gitlab provider v17 for GL modules
- Allow greater versions for Azure providers

## [0.6.0-alpha.3] - 2024-05-13

### 🚀 Features

- *(gitlab)* Use fast-forward merge strategy

## [0.6.0-alpha.2] - 2024-02-29

### 🚀 Features

- *(gitlab)* Allow different merge strategy than rebase_merge

## [0.6.0-alpha.1] - 2024-02-29

### 🚀 Features

- *(github)* New branch protection module
- *(github)* [**breaking**] Github branch protection is now a separate module

### 🚜 Refactor

- *(github)* [**breaking**] Remove branch protection for main and develop

### 🧪 Testing

- *(github)* Update tests

## [0.4.0] - 2022-06-24

### 🐛 Bug Fixes

- Use Suspended instead of Disabled

## [0.3.14] - 2022-05-13

### 🚀 Features

- Update aws impl
- Update tests

## [0.3.13] - 2022-03-15

### 💼 Other

- Make forcePush to main configurable
- Test azure

## [0.3.12f] - 2022-03-04

### 💼 Other

- Some fixes

## [0.3.12e] - 2022-03-04

### 💼 Other

- Allow squash
- Add vulnerability alerts

## [0.3.12d] - 2022-03-04

### 💼 Other

- Do not require a develop branch

## [0.3.12c] - 2022-03-04

### 💼 Other

- Wip
- Wip
- Wip
- Seems to work for now

## [0.3.13-alpha2] - 2022-03-01

### 💼 Other

- Remove version

## [0.3.13-alpha1] - 2022-03-01

### 💼 Other

- Fix warning
- Update provider

## [0.3.12a] - 2022-02-28

### 💼 Other

- Testing another BB provider

## [0.3.11] - 2022-02-28

### 💼 Other

- Lowercase?
- Do not yet enforce TF client versions

## [0.3.10] - 2022-02-25

### 💼 Other

- Wip
- Works
- Clarify release

## [0.3.9] - 2021-10-07

### 💼 Other

- Clarify rules for deep archive

## [0.3.8] - 2021-10-07

### 💼 Other

- Refactoring for storage class handling
- Fix issue with versioned+lifetime
- Remove obsolete tests

## [0.3.7] - 2021-10-04

### 🚀 Features

- Update kms policies

### 💼 Other

- Remove obsolete gradle stuff
- Deactivate major upgrade via param
- Allow setting of pagesLevel

## [0.3.6] - 2021-06-29

### 💼 Other

- Prep release

## [0.3.5] - 2021-06-29

### 💼 Other

- Remove tests
- Reuse module
- Idea to release via tagging
- Add stage

## [0.3.4] - 2021-05-12

### 💼 Other

- Allow not to reboot
- Monitor credit usage
- Wording
- Fix metric
- Remove volTags due to cycling
- Use std for cpu credit
- Wip
- Add aws eks auth module
- Update docs

## [0.3.3] - 2021-03-24

### 💼 Other

- Wip
- Seems to work
- Add route53 record weighted
- PackageEnabled flag
- Set approvals to 1
- Add mr approval idea
- Fix docs

## [0.3.1] - 2020-12-10

### 💼 Other

- Idea for swap volume
- Swp seems to work

## [0.3.0] - 2020-12-09

### 💼 Other

- Upgrade bb to tf 0.13
- Upgrade tests
- Upgrade to tf 0.13

## [0.2.13a] - 2020-12-08

### 💼 Other

- Add flag

## [0.2.13] - 2020-12-08

### 💼 Other

- Change branch name to main
- Code format
- Upgrade gitlab to tf 0.13
- Idea for reporters, devs, guests

## [0.2.12a] - 2020-11-24

### 💼 Other

- Fix array

## [0.2.12] - 2020-11-24

### 💼 Other

- Allow vpc ports
- Idea for unsecure egress
- Add ec2 test

## [0.2.11] - 2020-11-23

### 💼 Other

- More clarification about the handler
- Fix issue if the main branch name is NOT master..
- You add policies, not roles
- Remove obsolete variable
- More tests
- Upgrade db engine
- Some docs
- Allow at least port 22

## [0.2.10] - 2020-08-20

### 💼 Other

- Add new service

## [0.2.9] - 2020-08-20

### 💼 Other

- Allow empty environment

## [0.2.8] - 2020-08-20

### 💼 Other

- Make kms optional

## [0.2.7] - 2020-08-20

### 💼 Other

- Allow setting of unlimited flag
- More tests
- Initial idea
- Seems to work

## [0.2.6] - 2020-07-27

### 💼 Other

- Fix issue with on-time-deps
- Remove test instance

## [0.2.5] - 2020-07-27

### 💼 Other

- Allow push on release?
- Remove suffix as AWS does not allow it to be set
- Clarify var
- Idea to use ARNs
- Add idea for ec2 instance template
- Allow udp ports
- Reuse code
- Support sns, kms etc
- Outsource loggroup
- Add dns name
- Fix bug
- Tests

## [0.2.4] - 2020-06-30

### 💼 Other

- Allow disable of scan
- Allow disable of nat gateway in aws vpc
- Allow ipv4 only
- Code format

## [0.2.3] - 2020-06-23

### 💼 Other

- For sanity ;)
- Always have a maxStorage
- Remove sid as tf is complaining..??
- Add more permissions
- Initial idea
- Allow dynamic prefixes
- Register push ARNs
- Allow publicPull
- Fix permissions for publicPull again
- Remove test

## [0.2.2] - 2020-06-05

### 💼 Other

- Docs
- Ignore key
- Clarify some attributes
- Docs
- Fix?

## [0.2.1] - 2020-06-05

### 💼 Other

- Add module
- Run validation parallel
- No parallel mode??
- Again
- Preps for gradle
- Fix branch

## [0.2.0] - 2020-06-04

### 💼 Other

- Remove tests
- Fixes issue, will renew the db if rolled out!!
- Encrypt eks logs
- Retention is configurable

## [0.1.12] - 2020-06-04

### 💼 Other

- Idea to fix updating the subnet if a tag changed afterwards
- Add module for keypair
- Idea for a cloudwatch group
- Update
- More tests
- Change name
- Set version
- Update test
- Add bastion node
- Add alerts
- Fix issue with gateway
- Format
- Use other file
- Lower threshold
- Try with amd
- Extract resources
- Change namings of RTs
- More routing??
- Seems to work now
- Threshold configurable
- Ignore tags and ami changes
- Use separate ACLs for the subnets
- Only allow vpc
- Remove test instance
- Ignore manual changes
- Change name
- Fix params in db, fix retention
- Deactivate test

## [0.1.11] - 2020-06-02

### 💼 Other

- Remove tests
- Allow deactivation of CPUCreditBalance alert
- Allow different sec groups for db
- Update tests

## [0.1.10] - 2020-05-29

### 💼 Other

- Idea for some cw alerts
- Add sns idea
- Add test
- Allow non-ipv6 subnets
- Change name
- Works

## [0.1.9] - 2020-05-29

### 💼 Other

- Use prefix for kms keys
- Fix test
- Add json for sts ES aws
- Initial idea
- Add tags and logging
- Tests
- Use prefixes
- Done

## [0.1.8] - 2020-05-28

### 💼 Other

- More readme
- Add another tag name to an s3 bucket
- Initial idea
- Seems to work
- Add idea
- Branch protection setup
- Also add team
- Add hetzner cloud server module
- Initial idea
- Add id
- Add param group
- Testing
- Remove resource

## [0.1.7] - 2020-05-19

### 💼 Other

- Add role path
- Still works
- Allow null????

## [0.1.6] - 2020-05-19

### 💼 Other

- Allow descr
- Allow renderTemplate

## [0.1.5] - 2020-05-19

### 💼 Other

- Remove obsolete file
- Do not encrypt property files by default
- Add resource itself
- More permissions

## [0.1.4] - 2020-05-19

### 💼 Other

- Encrypt s3 bucket at least with the AES key from AWS
- Initial idea
- Add branch protections
- Add idea for jira and tag protection
- Test
- Test
- Testing with gitlab
- Encrypt
- Add link
- Reconfigure crypt keys
- Strange..
- No idea
- Add snippets

## [0.1.2] - 2020-05-15

### 💼 Other

- Fix output
- Fix test
- Only validate
- Fix test??
- Validate current dir
- Add cache??
- Simply validate
- Remove obsolete dir
- Test all modules

## [0.1.1] - 2020-05-15

### 💼 Other

- Updates, code format
- Output address
- More outputs

## [0.1.0] - 2020-05-15

### 💼 Other

- Initial idea
- Add readme

<!-- generated by git-cliff -->
