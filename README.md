<!-- 














  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated by the `build-harness`. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **















  -->

# terraform-aws-vpc



This is a terraform module that creates a vpc and public and private subnets
with optional nat instances or gateways.


---


This project is part of the [Guardian Project Ops](https://gitlab.com/guardianproject-ops/) collection.


It's free and open source made available under the the [APACHE2](LICENSE.md).










## Introduction


The VPC, nat-gateway, and nat-instance submodules are based off of
Cloudposse's  [vpc](https://github.com/cloudposse/terraform-aws-vpc)  and
[dynamic-subnets](https://github.com/cloudposse/terraform-aws-dynamic-subnets)
modules.



## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://gitlab.com/guardianproject-ops/terraform-aws-vpc/-/tags).



```hcl
module "vpc" {
  source  = "git::https://gitlab.com/guardianproject-ops/terraform-aws-vpc?ref=master"

  context = module.this.context

  cidr_block = "10.0.0.0/16"
  subnets = [
      {
        name = "public_1"
        availability_zone = "eu-central-1a"
        cidr_block = "10.0.0.0/24"
        public_route_enabled = true
        nat_instance_enabled = false
        nat_gateway_enabled = false
        nat_public_name = ""
      },
      {
        name = "private_1"
        availability_zone = "eu-central-1a"
        cidr_block = "10.0.1.0/24"
        public_route_enabled = false
        nat_instance_enabled = true
        nat_gateway_enabled = false
        nat_public_name = "public_1"
      },
      {
        name = "private_2"
        availability_zone = "eu-central-1b"
        cidr_block = "10.0.2.0/24"
        public_route_enabled = false
        nat_instance_enabled = false
        nat_gateway_enabled = true
        nat_public_name = "public_1"
      },
      {
        name = "rds_1"
        availability_zone = "eu-central-1a"
        cidr_block = "10.0.3.0/24"
        public_route_enabled = false
        nat_instance_enabled = false
        nat_gateway_enabled = false
        nat_public_name = ""
      }
    ]
}
```






## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| availability\_zones | The availability zones to create resources in | `list(string)` | n/a | yes |
| aws\_route\_create\_timeout | Time to wait for AWS route creation specifed as a Go Duration, e.g. `2m` | `string` | `"2m"` | no |
| aws\_route\_delete\_timeout | Time to wait for AWS route deletion specifed as a Go Duration, e.g. `5m` | `string` | `"5m"` | no |
| cidr\_block | Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | `string` | n/a | yes |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | n/a | yes |
| enabled | Set to false to prevent the module from creating any resources | `bool` | n/a | yes |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | n/a | yes |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | n/a | yes |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | n/a | yes |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | n/a | yes |
| nat\_gateways | Map where key is the AZ and value is the name of the subnet in which to place a NAT Gateway in this AZ. | `map(string)` | n/a | yes |
| nat\_instance\_type | NAT Instance type | `string` | `"t3.micro"` | no |
| nat\_instances | Map where key is the AZ and value is the name of the subnet in which to place a NAT Instance in this AZ. | `map(string)` | n/a | yes |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | n/a | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| subnets | A list of maps describing the subnets to create. | <pre>map(map(object({<br>    cidr_block           = string<br>    public_route_enabled = bool<br>  })))</pre> | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| availability\_zones | n/a |
| nat\_gateways | n/a |
| nat\_instances | n/a |
| private\_route\_tables | n/a |
| private\_subnets | n/a |
| public\_subnets | n/a |
| ssh\_security\_group\_id | n/a |
| vpc | n/a |




## Share the Love 

Like this project? Please give it a ★ on [GitLab](https://gitlab.com/guardianproject-ops/terraform-aws-vpc)

Are you using this project or any of our other projects? Let us know at [@guardianproject][twitter] or [email us directly][email]


## Related Projects

Check out these related projects.





## Help

File an [issue](https://gitlab.com/guardianproject-ops/terraform-aws-vpc/issues), send us an [email][email] or join us in the Matrix 'verse at [#guardianproject:matrix.org][matrix] or IRC at `#guardianproject` on Freenode.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://gitlab.com/guardianproject-ops/terraform-aws-vpc/issues) to report any bugs or file feature requests.

### Developing

If you are interested in becoming a contributor, want to get involved in
developing this project, other projects, or want to [join our team][join], we
would love to hear from you! Shoot us an [email][join-email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitLab
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Merge Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

## Credits & License 



Copyright © 2020-2020 [The Guardian Project](https://guardianproject.info)

Copyright © 2017-2020 [Cloud Posse, LLC](https://cloudposse.com)






[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.











See [LICENSE.md](LICENSE.md) for full details.

## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

**This project is maintained and funded by [The Guardian Project][website].**

[<img src="https://gitlab.com/guardianproject/guardianprojectpublic/-/raw/master/Graphics/GuardianProject/pngs/logo-black-w256.png"/>][website]

We're a [collective of designers and developers][website] focused on useable
privacy and security. Everything we do is 100% FOSS. Check out out other [ops
projects][gitlab] and [non-ops projects][nonops], follow us on
[mastadon][mastadon] or [twitter][twitter], [apply for a job][join], or
[partner with us][partner].







### Contributors

|  [![Abel Luck][abelxluck_avatar]][abelxluck_homepage]<br/>[Abel Luck][abelxluck_homepage] |
|---|

  [abelxluck_homepage]: https://gitlab.com/abelxluck

  [abelxluck_avatar]: https://secure.gravatar.com/avatar/0f605397e0ead93a68e1be26dc26481a?s=100&amp;d=identicon





[logo-square]: https://assets.gitlab-static.net/uploads/-/system/group/avatar/3262938/guardianproject.png?width=88
[logo]: https://guardianproject.info/GP_Logo_with_text.png
[join]: https://guardianproject.info/contact/join/
[website]: https://guardianproject.info
[cdr]: https://digiresilience.org
[cdr-tech]: https://digiresilience.org/tech/
[matrix]: https://riot.im/app/#/room/#guardianproject:matrix.org
[join-email]: mailto:jobs@guardianproject.info
[email]: mailto:support@guardianproject.info
[cdr-email]: mailto:info@digiresilience.org
[twitter]: https://twitter.com/guardianproject
[mastadon]: https://social.librem.one/@guardianproject
[gitlab]: https://gitlab.com/guardianproject-ops
[nonops]: https://gitlab.com/guardianproject
[partner]: https://guardianproject.info/how-you-can-work-with-us/
