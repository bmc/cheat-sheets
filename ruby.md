# Ruby Cheat Sheet

## RVM

<http://rvm.beginrescueend.com/>

### Installing RVM

Follow these instructions:

<http://rvm.beginrescueend.com/rvm/install/>

Next, be sure to issue `rvm notes` and install the appropriate dependencies,
*before* installing a Ruby.

### Gemsets

Worth using, to isolate gem sets. See <http://rvm.beginrescueend.com/gemsets/>

### SSL

    $ rvm package install openssl
    $ rvm package install zlib
    $ rvm remove 1.8.7
    $ rvm install 1.8.7 -C --with-zlib-dir=$rvm_path/usr --with-openssl-dir=$rvm_path/usr

See <http://rvm.beginrescueend.com/packages/openssl/>
