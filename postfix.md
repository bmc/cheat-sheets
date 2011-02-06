# Postfix Cheat Sheet

## Configuring Postfix to use Dovecot's SASL implementation

The Ubuntu guide, at <https://help.ubuntu.com/community/PostfixDovecotSASL>,
makes it easy.

## Virtual alias domains

Assuming DNS is properly set up:

First, list domains in the `virtual_alias_domains` setting in `main.cf`. e.g.:

    virtual_alias_domains = example.org example.com
    virtual_alias_maps = hash:/etc/postfix/virtual

Next, edit the virtual map (`/etc/postfix/virtual`, in this case) to have the
virtual domain address. e.g.:

    # Example.org
    foo@example.org    foo@clapper.org
    
    # Example.com
    foo@example.com    devnull@clapper.org

Then, run `postmap` to update the map:

    $ sudo postmap /etc/postfix/virtual

## DomainKeys

Using `dkim-filter`:

<https://help.ubuntu.com/community/Postfix/DKIM>

