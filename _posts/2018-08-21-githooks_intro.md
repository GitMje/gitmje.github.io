---
layout:     post
title:      Git hooks introduction
date:       2018-08-21 07:00:00
author:     Michael Erpenbeck
summary:    Git hooks intro
categories: hooks
thumbnail:  jekyll
tags:
 - git hooks
 - devops
---

Git hooks are a good way of enforcing controls on events within a git repository.  There are two types of git hooks.
1. Client-side hooks
2. Server-side hooks

# Client-side hooks

This may be obvious, but the client-side hooks are designed to control actions that the git user typically does client side.  Examples of this are `git commit` commands are controlled by `pre-commit` hooks.  Note the convention...some are named with the `pre-` prefix signifying that it runs before some event, and some are named with the `post-` prefix signifying that it runs after some event.

These are stored in the repo's `/.git/hooks` directory.  There are sample hooks in the hooks directory that are not active with the post-fix of `.sample`.  If you remove the post-fix and do a `chmod +x <filename>` on the hook, it will become active.

Here is an example of the `/.git/hooks/` directory:
![githook_intro_example1]({{ "/assets/githook_intro_example1.png" | absolute_url }})

Things that you may want to control with client-side hooks are:

* Allow a commit, if all unit tests execute cleanly without errors
* Allow a commit, if the commit message contains a Jira ticket prepended to the developer's commit message
* Allow a commit, if a code linter executes cleanly without errors

Something to note with this technique is that client-side hooks are not stored as part of the repository.  So, as an example, if you have a client-side hook on repo 123 of your laptop and go to a second machine with a clone of repo 123, the second machine will not have the client-side hook in the `/.git/hooks` directory.  I will discuss ways to share these types of hooks in future blog posts.

# Server-side hooks

If you are hosting your git repository in a host like GitHub, Bitbucket, etc, you can also have a server-side hook.  The types of events that can be controlled on the server-side is a bit different because it focused on network events.  An example of this is the `pre-push` hook, which controls the `git push` event on the server-side (host's side).  I will post more about server-side hooks in future blog posts.

For a good listing of git hooks, see [digtial ocean's blog](https://www.digitalocean.com/community/tutorials/how-to-use-git-hooks-to-automate-development-and-deployment-tasks).