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

## A suggested naming convention for branches

The forward slash is a little known trick in git naming conventions.  Instead of using a dash or underscore, the forward slash gets interpreted as a directory structure.  This is very nice for grouping.  Notice in the pictures below how the grouping makes the repo look different with the forward slashes.

### An example of a typical git repo without a convention

![typical-repo](/assets/2021-03-01-git-naming-conventions/typical-repo.png)

### An example of a git repo with a better organized naming convention

![better-repo](/assets/2021-03-01-git-naming-conventions/better-repo.png)

Notice how tools most git client tools like [GitKraken](https://www.gitkraken.com/), [Atlassian SourceTree](https://www.sourcetreeapp.com/), [Visual Studio](https://visualstudio.microsoft.com/), etc parse the branch name and convert them into a nice folder structure.

### An example with Atlassian SourceTree

![sourcetree](/assets/2021-03-01-git-naming-conventions/sourcetree.png)

### Visual Studio also recognizes this convention

![vs](/assets/2021-03-01-git-naming-conventions/visual-studio.png)


### Table of branch types

|Branch Type|convention|Example|
|:-:|--|--|
| Hotfix | `hotfix/(id)-(short-description)` | `hotfix/234-yikes-fix-it` |
| Feature | `feature/(id)-(short-description)` | `feature/647-update-radio-button` |
| Bug | `bug/(id)-(short-description)` | `bug/689-pen-test-finding` |
| Topic | `topic/(id)-(short-description)` | `topic/456-query-optimization` |
| User | `user/(user-id)/(short-description)` | `user/merpenbeck/sandbox` |
| Release | `release/(release-id)` | `release/2021-04-13`|

### Definition of terms in the above table

- `(id)` is a work item id for a bug, user story, task, etc. For example `123`.
- `(user-id)` is a user name such as `merpenbeck`.
- `(short-description)` is a phrase that is small and kebab-case, meaning it is all lower case with zero or more dash separators, such as `recursive-loop-fix`.
- `(release-id)` is a release identifier such as a semantic version number or date based.

### Topic branches

Not everyone likes the term `topic` as a generalized way of referring to a bug or a feature, but it does make things a bit simplier.

I hope that this will help in organizing your git repos.
