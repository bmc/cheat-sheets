---
title: SBT Cheat Sheet
layout: cheat-sheet
---

# Releasing/Publishing

First, ensure that the GPG plugin is available. Either in the project plugins
file or in `$HOME/.sbt/plugins/build.sbt`, include:

    addSbtPlugin("com.jsuereth" % "xsbt-gpg-plugin" % "0.6")

After `compile` and `test`, run a `+publish-local`. If that goes well,
run `+publish`.

    sbt> +publish

Next, follow the steps for deploying to Sonatype. See
<http://www.scala-sbt.org/using_sonatype.html>. That page also spells out
the POM extras and other data necessary to publish to Sonatype.

Add version info to `notes/version.markdown` (where `version` is replaced
with the actual version number).

Publish to `notes.implicit.ly` via [Herald](https://github.com/n8han/herald).

    $ herald --publish

Update the `ls` information:

    sbt> ls-write-version

Add the generated `ls` files to the Git repo, commit them, and
**push the change set to GitHub.** The next step won't work, unless the changes
are pushed to GitHub.

Publish `ls.implicit.ly` information:

    sbt> lsync

# `java.lang.NoClassDefFoundError` when invoking `sbt`

Most often, this is due to corrupted data in the `~/.sbt/boot` directory.
Just delete that directory and restart SBT.
