---
title: Cheat Sheets
layout: index
---

# Intro

This repository contains a set of cheat sheets on various topics. The cheat
sheets are maintained as [Markdown][] documents, as supported by the Ruby
[Kramdown][] gem. The documents are converted to HTML via [Rake][]; for
convenience, the resulting HTML is also maintained in the repo.

# The Cheat Sheets

{% include index_partial.md %}

# NO WARRANTY

I **do not** guarantee the accuracy of the information in these documents.
Specifically:

* The instructions in a document are generally correct, at that time I add
  them. But there's no guarantee that a particular cheat sheet hasn't suffered
  [bit rot][] and aged to irrelevance.
* Each instruction represents *one way* I discovered to solve a problem.
  There may be other ways, including *better* ways, to solve any particular
  issue.

If you follow my cheat sheets blindly, and terrible things happen to your
computer as a result, **it's not my fault**. I wrote these cheat sheets for
my own use. I maintain them here largely for convenience. If they're useful
to you, great, but the onus is on *you* to use them with care.

# Building the HTML Cheat Sheets Locally

If you'd like to build your own HTML copies of these cheat sheets:

* Clone [this repo][].
* Ensure that the [Bundler][] Ruby gem is installed (`gem install bundler`).
* Run `bundle install` to install the requisite gems.
* Run `bundle exec rake` to build a local copy of the site.

The resulting generated HTML will be in the `_site` directory; surf to the
`index.html` file. Alternatively, you can run `rake preview` to fire up a
local HTTP server on port 4000, to serve up the cheat sheets.

# Contact

Feel free to [email me](mailto:bmc@clapper.org) with suggestions, or fork
[this repo][] and send me pull requests.

[this repo]: http://github.com/bmc/cheat-sheets
[Kramdown]: http://kramdown.rubyforge.org/
[Markdown]: http://kramdown.rubyforge.org/syntax.html
[Rake]: http://rake.rubyforge.org/
[bit rot]: http://www.jargon.net/jargonfile/b/bitrot.html
[bundler]: http://gembundler.com/
