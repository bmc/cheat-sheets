---
title: Ruby Cheat Sheet
layout: cheat-sheet
---

# RVM

<http://rvm.beginrescueend.com/>

## Installing RVM

    $ bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )

More info is here: <http://rvm.beginrescueend.com/rvm/install/>

### Dependencies

Be sure to issue:

    $ rvm notes

and install the appropriate dependencies, *before* installing a Ruby.

## Gemsets

Worth using, to isolate gem sets. See <http://rvm.beginrescueend.com/gemsets/>

## SSL

Install the packages via rvm. Order matters here.

    $ rvm package install zlib
    $ rvm package install openssl
    $ rvm remove 1.8.7
    $ rvm install 1.8.7 -C --with-zlib-dir=$rvm_path/usr --with-openssl-dir=$rvm_path/usr

See <http://rvm.beginrescueend.com/packages/openssl/>

# Emacs Tags

Use [rtags][]:

    $ gem install rtags

[rtags]: http://rubyforge.org/projects/rtags/
