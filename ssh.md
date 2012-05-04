---
title: SSH Cheat Sheet
layout: cheat-sheet
---

# Configuration

## Defining a short name for a system

Edit `~/.ssh/config` and add the following:

    Host foo
    Hostname foo.example.org
    User bmc
    IdentityFile ~/.ssh/id_rsa

You can also use this approach to specify keyfiles that aren't in the
standard location. For instance:

    Host ec2prod
    Hostname ec2production.example.org
    User root
    IdentityFile ~/.ec2/production-keypair

After saving `~/.ssh/config`, you can use the alias names as if they were
actual host name:

    $ ssh ec2prod
