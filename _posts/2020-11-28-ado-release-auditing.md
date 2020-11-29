---
layout:     post
title:      Azure DevOps Release Auditing
date:       2020-11-28 22:00:00
author:     Michael Erpenbeck
summary:    Auditing Releases and Build Pipelines in Azure DevOps with Azure Log Analytics
categories: devops,azure
thumbnail:  jekyll
tags:
 - devops
 - azure
---

In a previous post, I discussed using [Azure DevOps to stream audit data to Log Analytics (Azure Monitor Log)](https://code.erpenbeck.io/devops,azure/2020/11/25/ado-auditing/){:target="_blank"}.

In this post, I am going to expand on how the `Pipelines` and `Release` Areas can be used.  Imagine if you want anyone in the organization to be able to create a release, release pipeline, or a build pipeline, but you want to know the moment that they create it.  Allowing for self-help is what DevOps is all about, "trust but verify" as the old saying goes.

## Monitor Release Creation ##

To create a query that will display any release created, including the person that created it, use the following query.
```
    AzureDevOpsAuditing 
    | where OperationName == 'Release.ReleaseCreated'
    | project TimeGenerated, OperationName, ActorDisplayName, Details
    | order by TimeGenerated
```
To test this query out, I will create a release in a release pipeline named `Test-1`. 
![ado-release-audit-1](/assets/2020-11-28-ado-release-auditing/ado-release-audit-1.png)

Here you can see that the resulting release is name `Release-1`.
![ado-release-audit-2](/assets/2020-11-28-ado-release-auditing/ado-release-audit-2.png)

I want to track this event in Azure DevOps via the query from above.  In the `Results` tab you can see that we've detected this event.
![ado-release-audit-3](/assets/2020-11-28-ado-release-auditing/ado-release-audit-3.png)

Creating an alert based on the query is pretty straight forward, see [Log Alerts](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-log#create-a-log-alert-rule-with-the-azure-portal){:target="_blank"} for more details.

## Monitor Release Pipeline Creation ##

Even more critical than Release Creation is monitoring Release Pipeline Creation.  Knowing who is creating pipelines in your company is not only important from a perspective of audits but for security in general.  If a bad actor finds a way to create a release pipeline, release to production through that new pipeline, and then delete the pipeline, you will see it in the logs with this approach and will be alerted immediately when the release pipeline is created.

The query for this is very similar.  The Only change is the OperationName changed from `Release.ReleaseCreated` to `Release.ReleasePipelineCreated`.

```
    AzureDevOpsAuditing 
    | where OperationName == 'Release.ReleasePipelineCreated'
    | project TimeGenerated, OperationName, ActorDisplayName, Details
    | order by TimeGenerated
```

Here is an example, where I create a release pipeline named `Test-2`.
![ado-release-audit-4](/assets/2020-11-28-ado-release-auditing/ado-release-audit-4.png)

Below is the results of the query:
![ado-release-audit-5](/assets/2020-11-28-ado-release-auditing/ado-release-audit-5.png)

## Monitor Build Pipeline Creation ##

Similar to the Release Pipeline Creation monitoring is Build Pipeline Creation monitoring. The query for this is:
```
    AzureDevOpsAuditing 
    | where OperationName == 'Pipelines.PipelineCreated'
    | project TimeGenerated, OperationName, ActorDisplayName, Details
    | order by TimeGenerated
```

Here is an example, where I create a build pipeline for the `Test-2` repository.
![ado-release-audit-6](/assets/2020-11-28-ado-release-auditing/ado-release-audit-6.png)

Below is the results of the query:
![ado-release-audit-7](/assets/2020-11-28-ado-release-auditing/ado-release-audit-7.png)

## Monitor Approvals ##

This is a very important question to answer for audits, "Who approves you releases?" and "Are your pre/post release gates working?".  To answer that, you can use the following query (note, I'm also adjusting to central time for simplicity).  I also limit it to only the stage `Prod` (auditors don't care about non-Production as much).  You can modify this to your own stage names or take the `where` condition out and search all stages:

```
    AzureDevOpsAuditing 
    | where Data.StageName == 'Prod'
    | where Area == "Release" and OperationName == "Release.ApprovalCompleted"
    | project ct_time = TimeGenerated -6h, ActorDisplayName, Data.PipelineName, Data.StageName, Data.ReleaseName, Details
    | order by ct_time desc
```

## Explore other Areas in AzureDevOpsAuditing ##

Hopefully this post has gotten you interested in what Azure DevOps Auditing streams can provide you.  There are other Areas that can provide even more visibiity into what is going on in your Azure DevOps Services instance, like the `Group`, `Policy`, `Git` and [many other Areas](https://docs.microsoft.com/en-us/azure/devops/organizations/audit/azure-devops-auditing?view=azure-devops&tabs=preview-page#areas){:target="_blank"}.
