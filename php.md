% PHP Cheat Sheet


## Chroot'ing PHP

Problem with chroot'd PHP: Can't find `mysql` extension.

Solution:

* Make sure mysql.so is in the extension dir. (Use `php-config` to figure
  out where that is.)
* Make sure dependent libraries are there.
* Make sure `/usr/local/etc/php.ini` exists (or wherever it belongs on the
  platform).
* In `php.ini` define the extension directory and include this line.

`php.ini`:

    extension=mysql.so
