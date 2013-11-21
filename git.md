---
title: Git Cheat Sheet
layout: cheat-sheet
---

# Useful Cheat Sheets on the Web

* <http://daniel.debian.net/documents/cheatpages/git.html>
* Hywel Carter's [Conceptual Git Cheatsheet](http://startuptechnology.files.wordpress.com/2013/11/git_cheatsheet.pdf) (PDF)
* GitHub

# Get rid of "push" warning

Getting rid of this warning:

    warning: You did not specify any refspecs to push, and the current remote
    warning: has not configured any push refspecs. The default action in this
    warning: case is to push all matching refspecs, that is, all branches
    warning: that exist both locally and remotely will be updated.  This may
    warning: not necessarily be what you want to happen.
    warning: 
    warning: You can specify what action you want to take in this case, and
    warning: avoid seeing this message again, by configuring 'push.default' to:
    warning:   'nothing'  : Do not push anything
    warning:   'matching' : Push all matching branches (default)
    warning:   'tracking' : Push the current branch to whatever it is tracking
    warning:   'current'  : Push the current branch


    $ git config push.default matching
    $ git config --global push.default matching

See <http://pivotallabs.com/users/alex/blog/articles/883-git-config-push-default-matching>

# Sync local repo with remote branches

Someone has created a new, remote branch. To get your local repo to see the
branch, so you can do a `git checkout`:

    $ git fetch
    $ git checkout newbranch

# Create a remote branch

Create a local branch, then push it to the server. General syntax:

    $ git push REMOTE LOCALBRANCH:REMOTEBRANCH

The remote branch name can be omitted if it's the same name as the local
branch.

    $ git co -b mybranch
    $ git push origin mybranch

# Delete a remote branch

    $ git push remotename :branch

e.g.:

    $ git push origin :testbranch

You are literally telling git "push nothing into BRANCHNAME on REMOTENAME".

# Create a bare repository

New:

    $ mkdir foo.git && cd foo.git
    $ git --bare init

From an existing repo:

    $ git clone --bare /path/to/existing/repo proj.git

# Mark conflict resolved

    $ git add file

# Rename a tag

From <http://stackoverflow.com/questions/1028649/rename-a-tag-in-git>:

    git tag new old
    git tag -d old
    git push origin :refs/tags/old
    git push --tags
