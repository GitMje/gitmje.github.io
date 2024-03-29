---
layout: post
title: Azure Naming Conventions
date: 2022-02-09 22:00:00
author: Michael Erpenbeck
summary: Azure naming conventions
categories: Azure
thumbnail: jekyll
tags:
  - Azure
---

## Summary

I have been using the following standards and conventions with the Azure Cloud Platform for years.  I've found it to be critial in working with teams to be opinionated in the conventions used as most teams need this level of structure but your milage may vary.  This becomes particularly important when your team starts to implement Infrastructure-as-Code with a technology like Terraform, as all of the rules need to be well-understood.

I developed them before [Microsoft created their documentation](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).  Surprisingly, we ended up with a very similar structure.  I keep my resource abbreviations to be the same as [Microsoft's resource abbreviations guidance](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations).

The main differences is that I put the resource type at the end of my convention and they put it at the beginning.  My reasoning is that the resource type is typically less relevant than the ownership and purpose for the resource and that a convention should always go from general to specific.

I also like to develop patterns (codes) that I can use regular expressions and automation to access and ensure proper resource controls.  For example, I know the number of characters that the `<DepartmentCode>` will be and where it will reside be with relation to the dashes.  Even more important than the pattern is keeping the resource name within the associated length defined by Azure.  This means that I can search for these patterns and enforce them.

Regarding the subscription naming, I'm a big believer in getting the subscription level down to a physical team level.  The reason for this is billing.  I want the teams to be responsible for their own subscriptions and to have Billing Consumption reports built into the subscription.

Additionally, I like to use a `-prod` and a `-nonprod` designation on subscriptions for regulated companies that need to keep different controls and budgeting on production vs non-production environments and different controls on the sensitive data stored in them.  For example, developers can access `-nonprod` freely, but `-prod` is more controlled.

Below I have my recommendations.  The items in the angular brackets means that it is defined in the [Glossary](#glossary) below. `?` means that the code is optional but I suggest that you're final standards have no optional items.  I also use some of these codes for Azure Tags for a convenient way to query for the information.  You may decide that you prefer to use some of these codes as tags instead of putting them into your resource names at all, in the end the choice is up to you.  I will write more on Azure Tagging in the future, but here's a [good article](https://cloudskills.io/blog/azure-policy-tagging) if you're not familiar with it.

## General Entities

| Entity | Scope | Length | Casing | Valid Characters | Required Pattern | Example |
|--|--|--|--|--|--|--|
| **Subscription** | Subscription | 1-64 | Insensitive | All characters | `?<Company>-<DepartmentCode>-<WorkloadCode>-<ServiceLevelCode>` | `it-sap-prod` |
| **Resource Group** | Subscription | 1-90 | Insensitive | Alphanumeric, hyphens, underscores, periods (except at end), and parentheses | `?<DepartmentCode>-?<WorkloadCode>-?<PurposeCode>-<ServiceLevelCode>-<LocationCode>-rg` | `it-sap-env-prod-zet-rg` |
| **Tag** | Associated Entity | 512 (named), 256 (value) | Insensitive | Alphanumeric including Unicode characters; special characters except <, >, %, &, \, ?, /. See limitations here . Maximum of [50](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources?tabs=json#limitations). | `"key" : "value"` | `"department" : "DevOps"` |
| **Key Vault** | Global | 3-24 | Insensitive | Alphanumeric and hyphens | `<Company>-?<DepartmentCode>-?<WorkloadCode>-<ServiceLevelCode>-vlt` | `acme-it-sap-dev-kv` |
| **Service Principal** | Scope-dependent | 1-120 | Insensitive | Alphanumeric and hyphens (not < > ; & %) | `?<DepartmentCode>-?<WorkloadCode>-<ServiceLevelCode>-<LocationCode>-<AccessCode>-sp` | `it-sap-dev-zet-reader-sp` |

## Glossary

### `<CompanyCode>`

This is useful if your company has many subsidiaries or for resources that are globally scoped and need to be unique in all of Azure.

### `<DepartmentCode>`

2 characters to represent the associated Department. (see examples below)
| Abbreviation | Description |
|--|--|
| AC | Accounting |
| IT | Information Technologies |
| EN | Engineering |

### `<WorkloadCode>`

3 letter code for the workload that the resource is related to.  This could be a product, application, etc that you're working on, or team within a department.

|Code| Team Name |
|--|--|
| **sap** | The SAP component of the application, if one exists. |
| **ops** | The operational team within IT |
| **dot** | The DevOps team |
| **spm** | The Stay Puft Marshmallow development team |

### `<LocationCode>`

3 characters to represent the location of the VM.  This can be a cloud region or it can be a physical datacenter.  I try to use airport appreviations for the city if one exists that defines the city.

| Code | Description |
|--|--|
| CHI | Chicago Data Center|
| PGH | Pittsburgh Data Center |
| ZET | Microsoft Azure US East |
| ZWT | Microsoft Azure US West |
| ZWC | Microsoft Azure US West Central |
| WET | AWS US East  |
| WWT | AWS US West  |

### `<ServiceLevelCode>`

1 character for the lifecycle stage of development.  In the past, I called this field `<EnvironmentCode>` as I thought of these resources as environments.  I quickly realized that terming this code as a service level makes more sense.  The usefulness of this code is mostly around lifecycle and required support of its environments and resources.

|Code | Abbreviation | Description |
|--|--|--|
| A | train |Tr**a**ining |
| B | bld |**B**uild |
| C | poc | Proof of **C**oncept |
| D | dev | **D**evelopment |
| F | perf |Per**f**ormance Testing |
| H | hf |**H**otfix |
| I | inf | **I**nfrastructure (SMTP Servers, etc) |
| N | np |**N**on-Production |
| O | demo |Dem**o** |
| P | prod |**P**roduction |
| R | pr |Pull **R**equest environment |
| *R`*`* | dr |Disaster **R**ecovery |
| S | sta |**S**taging/Stable|
| T | test |**T**est/QA|
| U | uat | **U**ser Acceptance Testing |
| X | sbox | Sandbo**x** |

### `<PurposeCode>`

3 character code for the role/purpose of the resource.

|Code| Description |
|--|--|
| APP | Application server (Windows Services, Console Applications) |
| BLD | On-Premise Build Server |
| ENV | A resource group containing the entire environment (e.g., web servers, dbs, etc.) |
| EXC | Exchange Server |
| FIL | File Server |
| PRT | Print Server |
| SQL | SQL Server |
| WEB | Web App/API Server |

### `<AccessCode>`

The level of access that a service principal, etc is [allowed](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).

|Code| Description |
|--|--|
| reader | Read-only permissions |
| contributor | Read/Write permissions |
| owner | Root permissions |

### `<Description>`

Free form field for any notes or descriptions about the resources.

* `*` Note: if you are considering using a [blue/green deployment pattern](https://martinfowler.com/bliki/BlueGreenDeployment.html), then all servers, include Disaster Recovery servers will be Production (prod) servers, they will just be switched from one set of servers to the others, or generated on demand.