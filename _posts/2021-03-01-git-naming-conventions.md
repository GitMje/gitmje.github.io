---
layout:     post
title:      Organizing git branches with naming conventions
date:       2021-03-01 22:00:00
author:     Michael Erpenbeck
summary:    git naming conventions
categories: git
thumbnail:  jekyll
tags:
 - git
---

## An opinionated convention for branches

The forward slash is a little known trick for developers that are new to git.  Instead of using a dash or underscore, the forward slash gets interpreted by many IDEs and git tools as a directory structure.  This creates a very nice grouping.

As an example, creating a branch named `feature/647-update-radio-button` rather than something like `feature-647-update-radio-button` will result in better organization within your git tools.  Notice in the pictures below how the grouping makes the repo look different with the forward slashes.

### Slashes in git branch names result in better organized naming convention

![better-repo](/assets/2021-03-01-git-naming-conventions/better-repo.png)

### Example of a typical git repo without a convention

![typical-repo](/assets/2021-03-01-git-naming-conventions/typical-repo.png)

Most git client tools like [GitKraken](https://www.gitkraken.com/){:target="_blank"}, [Atlassian SourceTree](https://www.sourcetreeapp.com/){:target="_blank"}, [Visual Studio](https://visualstudio.microsoft.com/){:target="_blank"}, etc parse the branch name and convert them into a nice folder structure.

### An example with Atlassian SourceTree

![sourcetree](/assets/2021-03-01-git-naming-conventions/sourcetree.png)

### Visual Studio also recognizes this convention

![vs](/assets/2021-03-01-git-naming-conventions/visual-studio.png)

### Table of branch types

| Type | Pattern | Example |
|:-:|:--|--|
| Bug | `bug/(id)-(short-description)` | `bug/689-pen-test-finding` |
| Feature | `feature/(id)-(short-description)` | `feature/647-update-radio-button` |
| Topic | `topic/(id)-(short-description)` | `topic/456-query-optimization` |
| Hotfix | `hotfix/(id)-(short-description)` | `hotfix/234-yikes-fix-it` |
| User | `user/(user-id)/(short-description)` | `user/merpenbeck/sandbox` |
| Release | `release/(release-id)` | `release/2021-04-13`|
| Support | `support/(id)-(short-description)` | `support/876-app-support-reboot-fix`|
| Bugfix (alternative) | `bugfix/(id)-(short-description)` | `bugfix/689-pen-test-finding` |

While I use [kebab-case](https://betterprogramming.pub/string-case-styles-camel-pascal-snake-and-kebab-case-981407998841){:target="_blank"}, meaning it is all lower case with zero or more dash separators, in this convention, feel free to use whatever style that you prefer, such as PascalCase camelCase, etc.  The convention for the wording between the slashes should be determined by the team's preferences.

### Definition of terms in the above table

- `(id)` is a work item id for a bug, user story, task, etc. For example `123`.
- `(user-id)` is a user name such as `merpenbeck`.
- `(short-description)` is a phrase, such as `recursive-loop-fix`.
- `(release-id)` is a release identifier such as a semantic version number or date based.

### Branch prefix support within git workflow tools

Beyond git UI clients, this convention is also built directly into the branch prefixes for some git workflows like [gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow){:target="_blank"}.

Notice that if you plan to use gitflow, you may want to use `bugfix` rather than `bug`, but you can also configure gitflow to use the `bug` branch prefix instead.

![gitflow](/assets/2021-03-01-git-naming-conventions/gitflow.png)

### Source code repository support

Hosted source code repositories, such as Azure DevOps Repos, have built-in support for the branch prefixes:
![ado-example](/assets/2021-03-01-git-naming-conventions/ado-example.png)

Additionally, tools like Bitbucket allow you to create branches with a branch prefix.
![bb-1](/assets/2021-03-01-git-naming-conventions/bb-1.png)

And filtering by branch prefix is also enabled based on the gitflow workflow.
![bb-2](/assets/2021-03-01-git-naming-conventions/bb-2.png)

### Some places where teams have issues

1. Not everyone likes the term `topic` as a generalized way of referring to a bug or a feature, but it does make things a bit simpler.  Decide as a team how you want to approach `topic` branches.
2. Often team members accidently use `users` rather than `user`, which results in duplicate folders in these tools.  I typically advise to use the singular case as `feature`, `bug`, etc are all singular case as well.
3. Case matters, so `Feature` and `feature` will similarly result in duplicate folders.  This comes down to being disciplined on naming and using scripting for building branches where you can.

I hope that this will help in organizing your git repos.
