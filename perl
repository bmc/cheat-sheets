autom4te

1. If you get this error:

----
File::Recurse::recurse() called too early to check prototype at /usr/local/lib/perl5/site_perl/5.005/File/Recurse.pm line 49.
autom4te: too few arguments
Try `autom4te --help' for more information.
----

then you're pulling in an older version of File::Recurse (or one for an
older version of perl). Use CPAN to install a new one. Or use cpan.org to
find Recurse.pm and install it manually.

NOTE: Might need to move old one out of the way.

2. Another common error:

        Undefined subroutine &Autom4te::move called at /usr/local/bin/autom4te line 628.

Problem appears to be an incompatibility between autoconf and p5-File-Tools.
Remove the p5-File-Tools package, and the problem goes away. See the message
to "freebsd-stable" in the "autom4te.mail" file in this directory.

