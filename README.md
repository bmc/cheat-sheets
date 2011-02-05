# Cheat Sheet README

## Intro

This repo contains a bunch of cheat sheets in Markdown format. The cheat
sheets are maintained as [Markdown][] documents, as supported by the Ruby
[Kramdown][] gem. The documents are converted to HTML via [Rake][]; for
convenience, the resulting HTML is also maintained in the repo.

## Building and/or reading

Ensure that you have RubyGems installed, as well as the `kramdown` gem.
Then, simply issue `rake` to build/rebuild the HTML versions of the cheat
sheets.

Or, just read the Markdown source files.

## NO WARRANTY

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

# Contact

Feel free to [email me](bmc@clapper.org) with suggestions, or fork
[this repo][] and send me pull requests.

Brian Clapper

[this repo]: http://github.com/bmc/cheat-sheets
[Kramdown]: http://kramdown.rubyforge.org/
[Markdown]: http://kramdown.rubyforge.org/syntax.html
[Rake]: http://rake.rubyforge.org/
[bit rot]: http://www.jargon.net/jargonfile/b/bitrot.html
