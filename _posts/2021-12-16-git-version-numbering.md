---
layout: post
title: git Version Numbering
date: 2021-12-16 22:00:00
author: Michael Erpenbeck
summary: git Version Numbering
categories: git
thumbnail: jekyll
tags:
  - git
---

## Summary

When releasing a new product, you will want to version the new software.  A lot of git software versioning standards exist, but my the two schemes that I prefer working with are:
1. [SemVer](https://semver.org/) or
2. [CalVer](https://calver.org/).

## Which to use ❓
Both techniques use the <span style="color:royalblue">Major</span>.<span style="color:green">Minor</span>.<span style="color:orange">Patch</span>[.<span style="color:yellow">BuildNumber]</span> structure. See [Major.Minor.Patch](https://medium.com/fiverr-engineering/major-minor-patch-a5298e2e1798) for a good definition of the terms.

The decision criteria that I use is very simple, if the repository that you are building has clients with strong dependencies, then SemVer is the best choice.  This is often the case for repositories with web APIs and open source software.  The reason for this is that SemVer focuses on the amount of change to the codebase to communicate the downstream affect on clients.  If not, I suggest the use of a simpler standard like CalVer.

## SemVer 💔

SemVer can be tricky but some tools like [gitVersion](https://github.com/GitTools/GitVersion) and [standard-version](https://github.com/conventional-changelog/standard-version) can help make it much simplier.  I believe that a build/deployment systems should not require engineers to decide whether to bump a major/minor version number but should rather run on an automated rule set of when to bump the numbers.  Having engineers manually bump the version numbers is subjective, inefficient, and waist engineer's time.

Due to SemVer's focus on breaking changes, I prefer the renaming of the above structure to <span style="color:royalblue">Breaking</span>.<span style="color:green">Feature</span>.<span style="color:orange">Fix</span>[.<span style="color:yellow">BuildNumber]</span>.  Where:
-  <span style="color:royalblue">Breaking</span> represents a incompatible change with the previous version, 
- <span style="color:green">Feature</span> represents a backwards compatible functionality and 
- <span style="color:orange">Fix</span> is a backwards compatable bug fix.

## CalVer 📆

Years ago, I worked at a company that was very strict on version numbering. The decision of the final version number went to the Director and CTO levels for the final decision. I asked the CTO if we could do an experiment and use `YY.M.D.I` where each number came from the date of the build. It is basically just a date stamp.

My argument was that if SemVer is done by hand by humans, it is likely to be arbitrary and subjective. When most engineers would look at a build/release, the first question they often ask was "when was this built?". So why not encode the date into the version number rather than have a subjective value built by hand?  

This way, you always know what date it was built and it always increments forward.  Also, the <span style="color:royalblue">Major</span> increments at a reasonable rate rather than being a ridiculous value in the thousands or 10's of thousands (within 1,000+ years, the app will be rewritten or will be Captain Kirk's responsibility, not ours :) ).

We tried this approach and started with 13.8.1.1 (meaning the first build on August 1st of 2013). The approach worked really nicely and did not require human interaction to decide or increment the numbers as scripting could figure out all of the elements above.

A similar approach that has become popular is called CalVer. Here's a good [comparison between SemVer and CalVer](https://mikestaszel.com/2021/04/03/semver-vs-calver-and-why-i-use-both/).

In 2019, I worked at a company and they liked this approach, but their current software was on `8.x.x`. They thought that decrementing that value to anything less than 8 or incrementing to it 19 or 2019 would confuse the customer, so the `YY`/`YYYY` approach was out. 

So I offered two solutions, either go with `9.x.x` (meaning that you always subtract the current year by 2010), or stay with `8.x.x` and always subtract by 2011. They went with the 2011 approach to keep the continuity of the <span style="color:royalblue">Major</span> number. It worked nicely, but didn't help much with the "when was it built" question as it wasn't as intuitive to subtract by an arbitrary number.

## Side Notes 📝

- In Azure DevOps Pipelines, the YAML [counter](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/expressions?view=azure-devops#counter) mechanism can be very useful as it will increment the number until a dependent variable increments at which time the counter resets.  For example, the <span style="color:yellow">BuildNumber</span> number is a natural fit for this.
- Many engineers assume that version numbers for packages (like npm and NuGet) should be stamped with the same numbers as the main release.  This is not the case.  Every pipeline should use their own version numbers.  If this is confusing to the customer, it's fine to create a manifest of which package versions go in to build a specific customer version of the code (and sometime marketing customer version numbers can differ from the pipeline numbers, which is fine although not as efficient).
- With the date stamp CalVer approach, a common gotcha is that you need to ensure that you define the time zone that the version number will use. For example, build servers with different time zones can confuse the teams.  Some teams use UTC to be fully international and some use the default time zone of the company (e.g., US EST, US CST, etc).
- Some teams use `-alpha`/`-beta`/etc pre-release labels rather than or in addition to an <span style="color:yellow">BuildNumber</span> value to signify the maturity of the build.

## Final note ❌

In the end, both SemVer and CalVer are fantastic standards that (once fully-automated by tools like gitVersion) will save your team lots of time and energy and will fuel your agility.