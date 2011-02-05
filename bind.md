title: BIND Cheat Sheet

## Determining version of BIND running on a server

    $ dig @server version.bind chaos txt

To configure BIND not to give out the version, include the following in
the `options` portion of `named.conf`:

    version "surely you must be joking";

