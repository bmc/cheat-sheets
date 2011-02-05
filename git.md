title: Git Cheat Sheet

## Useful Cheat Sheets on the Web

* <http://daniel.debian.net/documents/cheatpages/git.html>
* GitHub

## Get rid of "push" warning

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

## Delete a remote branch

    $ git push REMOTENAME :BRANCHNAME

If you look at the advanced push syntax above it should make a bit more
sense. You are literally telling git "push nothing into BRANCHNAME on
REMOTENAME".

## Create a bare repository

New:

    $ mkdir foo.git && cd foo.git
    $ git --bare init

From an existing repo:

    $ git clone --bare /path/to/existing/repo proj.git

## Mark conflict resolved

    $ git add file

## Delete a remote branch

    $ git push remotename :branch

e.g.:

    $ git push origin :testbranch
