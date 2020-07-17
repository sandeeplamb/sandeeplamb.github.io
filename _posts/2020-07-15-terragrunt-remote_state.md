---
layout: post
title:  "Terragrunt - Multiple Buckets remote_state"
author: Sandeep
categories: [ Terraform, Tutorial, Terragrunt, AWS, Cloud ]
image: assets/images/common/terragrunt.png
featured: true
hidden: true
comments: false
---
Approach to create different Remote-Buckets in same environment in Terragrunt for different products and accounts.

<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/styles/vs2015.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

## Terragrunt
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

> [Terragrunt](https://terragrunt.gruntwork.io/) is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.

We are using [Terragrunt](https://terragrunt.gruntwork.io/) for all our infrastructure code that we deploy in different environments. <br> 
[Terragrunt](https://terragrunt.gruntwork.io/) helps us too, to keep the [Terraform](https://www.terraform.io/) code DRY across all of our environments. <br> 

## Terragrunt - remote_state
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

[Terragrunt](https://terragrunt.gruntwork.io/) uses **remote_state** block to configure and set up the remote state configuration of Terraform code. <br> 
A basic block of **remote_state** that one might keep in `terragrunt.hcl` looks like below <br> 

<pre><code>remote_state {
    backend = "s3"
    config = {
      bucket = "your_remote_bucket"
      key    = "path/to/your/key"
      region = "us-east-1"
    }
  }
</code></pre>

Above piece of code snippet will create a remote bucket where terraform state file will be stored. 

This code works well if you have a single account, and many environments. It will keep your code DRY and create a dedicated bucket per environment. 

**But what if you want to maintain same code, same environments but with different accounts.**

## Terragrunt - Current remote_state 
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

Consider this directory structure

<pre><code>.
├── dev
│   ├── common
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── ecs
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── kms
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
├── common.yaml
└── terragrunt.hcl
</code></pre>

and code for `terragrunt.hcl`

<pre><code>locals {
  team          = "team-a"
  infra         = "infra-project-a"
  unit          = "mobile"
  cloud         = "hybrid"
  aws_region    = "eu-west-1"
  common        = yamldecode(file(find_in_parent_folders("common.yaml")))
  tags          = merge(local.common.base_tags,)
  secrets_path  = "${get_terragrunt_dir()}/secrets.yaml"
  secrets       = yamldecode(fileexists(local.secrets_path) ? file(local.secrets_path) : "{}")
}

remote_state {
  backend               = "s3"
  config                = {
    encrypt             = true
    bucket              = join("-", [ lower(local.team), lower(local.infra), lower(local.unit), lower(local.cloud), lower(local.aws_region), "tfstate", ])
    key                 = "${local.unit}.tfstate"
    region              = local.aws_region
    dynamodb_table      = join("-", [lower(local.team),lower(local.infra),lower(local.unit),lower(local.cloud),lower(local.aws_region),"tflock", ])
    s3_bucket_tags      = local.tags
    dynamodb_table_tags = local.tags
  }
}
</code></pre>

From above code, AWS S3 will be created by `Terragrunt` using `remote_state` block code. <br> 
Name of the S3 will be a join of all these local variables i.e. `team-a-infra-project-a-mobile-hybrid-eu-west-1-tfstate`.
<pre><code>bucket = join("-", [ lower(local.team), 
    lower(local.infra), 
    lower(local.unit), 
    lower(local.cloud), 
    lower(local.aws_region), 
    "tfstate", 
    ])
</code></pre>

File `common/terragrunt.hcl` just need to have `include` block to get parent folder.<br> 
<pre><code>include {
  path = find_in_parent_folders()
}
</code></pre>

This works well if we are working on same Account. 

What if we want to override top level `terragrunt.hcl` local parameters so that name of bucket in new Account will be different.

## Terragrunt - New remote_state 
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block"> 
Consider, we have `new` AWS account and we want to deploy same code in `new` AWS account. We created the below directories with  `terragrunt.hcl`. 

But when we run the code in `new` AWS account, we will get an error saying `S3 already exists`.

Since S3 shares DNS namespace, name of S3's has to be unique across globe.
<pre><code>.
├── dev
│   ├── common
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── ecs
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── kms
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── common-new-account
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── ecs-new-account
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── kms-new-account
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
├── common.yaml
└── terragrunt.hcl
</code></pre>

We need to override one of the below params present in `bucket` join function so that unique S3 name can be generated.

<pre><code>bucket = join("-", [ lower(local.team), 
    lower(local.infra), 
    lower(local.unit), 
    lower(local.cloud), 
    lower(local.aws_region), 
    "tfstate", 
    ])
</code></pre>

## Terragrunt - locals
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block"> 
Terragrunt [locals](https://terragrunt.gruntwork.io/docs/features/locals/) is a block, and there is not a way currently to merge the map from child level directory into the top level.

So, if we want to override the locals in child `terragrunt.hcl`, parent `terragrunt.hcl` will not be updated.

Terragrunt [locals](https://terragrunt.gruntwork.io/docs/features/locals/) will not help us.

## Terragrunt - Override
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block"> 

I will be overriding below params so that `remote_state` makes a unique S3 in my new account.

<pre><code>bucket = join("-", [ lower(local.team), 
    lower(local.infra), 
    lower(local.unit), 
    lower(local.cloud), 
    lower(local.aws_region), 
    "tfstate", 
    ])
</code></pre>

I will create `overrides.yaml` in child product directory as shown below and can contain params what we want to override in parent `terragrunt.hcl`.

<pre><code>.
├── dev
│   ├── common
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── ecs
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── kms
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   ├── common-new-account
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   │   └── overrides.yaml
│   ├── ecs-new-account
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   │   └── overrides.yaml
│   ├── kms-new-account
│   │   ├── secrets.yaml
│   │   └── terragrunt.hcl
│   │   └── overrides.yaml
├── common.yaml
└── terragrunt.hcl
</code></pre>

<pre><code>base_s3:
  a_team: "team-a"
  b_infra: "infra-project-b"
  c_unit: "desktop"
  d_cloud: "onprem"
  e_aws_region:  "eu-west-1"
</code></pre>

Now to override the params in parent `terragrunt.hcl`, lets include our `overrides.yaml` in parent `terragrunt.hcl` as shown below.

<pre><code>locals {
  team            = "team-a"
  infra           = "infra-project-a"
  unit            = "mobile"
  cloud           = "hybrid"
  aws_region      = "eu-west-1"
  common          = yamldecode(file(find_in_parent_folders("common.yaml")))
  tags            = merge(local.common.base_tags,)
  secrets_path    = "${get_terragrunt_dir()}/secrets.yaml"
  secrets         = yamldecode(fileexists(local.secrets_path) ? file(local.secrets_path) : "{}")
  overrides_path  = "${get_terragrunt_dir()}/overrides.yaml"
  overrides       = yamldecode(fileexists(local.overrides_path) ? file(local.overrides_path) : "{}")
  overridden      = fileexists(local.overrides_path) ? merge(local.overrides.base_s3) : {}
}

remote_state {
  backend               = "s3"
  config                = {
    encrypt             = true
    bucket              = fileexists(local.overrides_path) ? lower(format("%s-tfstate", join("-", values(local.overridden)))) : join("-", [ lower(local.team), lower(local.infra), lower(local.unit), lower(local.cloud), lower(local.aws_region), "tfstate", ])
    key                 = "${local.unit}.tfstate"
    region              = local.aws_region
    dynamodb_table      = join("-", [lower(local.team),lower(local.infra),lower(local.unit),lower(local.cloud),lower(local.aws_region),"tflock", ])
    s3_bucket_tags      = local.tags
    dynamodb_table_tags = local.tags
  }
}
</code></pre>

You can see our bucket expression changed a bit. If the file exists `overrides.yaml` in current child directory, name of bucket will come from file `overrides.yaml` params.

If `overrides.yaml` doesn't exists i.e in case of older account child directory, same old logic to join locals will run.

<pre><code>bucket = fileexists(local.overrides_path) 
    ? 
    lower(format("%s-tfstate", join("-", values(local.overridden)))) 
    : 
    join("-", [ 
          lower(local.team), 
          lower(local.infra), 
          lower(local.unit), 
          lower(local.cloud), 
          lower(local.aws_region), 
          "tfstate", 
          ]
        )
</code></pre>

## Conclusion
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block"> 
[Terragrunt](https://terragrunt.gruntwork.io/) is great tool to make terraform code very DRY. But to make terragrunt code change according to your use-case, we need to do some tricks with it.

We faced the same issue and solved that too. Of course, there are more than 1 solution to solve same problem. But for us, this suited the best.
