---
layout:     post
title:      Azure Automation authentication basics
date:       2018-10-15 20:00:00
author:     Michael Erpenbeck
summary:    Azure Automation authentication basics
categories: Azure,Automation
thumbnail:  jekyll
tags:
 - azure
 - devops
 - automation
---

There's three ways to control permissions within Azure Automation.  I learned about this from the "Microsoft Azure Essentials Azure Automation" book.  It is a free Kindle book from Microsoft Press and is an easy read.

1. Certificates;
2. Set the "Create Run As Account" to yes when creating the Azure Automation resource; or
3. Use an Azure Automation credential asset.

- **Option 1** - (certs) this option is deprecated by Microsoft.
- **Option 2** - is the easier way that makes security really simple. It is not necessarily best if you want fine grained control of security within the Azure Automation resource.  It will create two cert accounts (one account for AzureRm commands and one account for the deprecated Azure cmdlets).  The password will never expire, but the account will have access to the full subscription.
- **Option 3** - is more complicated and the password will expire periodically but gives you finer levels of control (for example you can have multiple credential assets with different level of permissions to a given resource).  Note: you can create a runbook that will reset the pw periodically so that the password management is automated and invisible to humans.

  In the end, like all non-trival architectural decisions, you will need to decide which approach is best for you...none of them are a perfect silver bullet for every team type.