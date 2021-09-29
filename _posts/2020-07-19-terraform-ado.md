---
layout:     post
title:      Terraform the Cloud with Azure DevOps
date:       2020-07-19 10:00:00
author:     Michael Erpenbeck
summary:    Terraform
categories: Azure
thumbnail:  jekyll
tags:
 - Azure
---

There is a [new ADO Terraform provider](https://adinermie.com/deploying-azure-devops-ado-using-terraform/){:target="_blank"} that is very handy.  

One of the less obvious tricks for building Terraform pipelines is the question "how does the `terraform plan` command fit into the whole pipeline?!?".  If done correctly, it creates a nice mechanism for seperation of concerns.  Create a distinct "Plan Step" and give the permissions to Operations teams (SRE/Support) be able to inspect and approve the plan before the `terraform apply` command occurs.  It is super powerful.  

See
[Terraform plan in section 8.3.4.](https://medium.com/@gmusumeci/deploying-terraform-infrastructure-using-azure-devops-pipelines-step-by-step-d58b68fc666d){:target="_blank"} for how to do this.