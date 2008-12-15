1. Problem with chroot'd PHP on wildbean: Can't find mysql extension.
   Solution:

   - Make sure mysql.so is in the extension dir. (Use php-config to figure
     out where that is.)
   - Make sure dependent libraries are there.
   - Make sure /usr/local/etc/php.ini exists
   - In php.ini, define the extension directory and include this line:

	extension=mysql.so
