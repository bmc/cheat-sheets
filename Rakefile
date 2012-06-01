#                                                                -*- ruby -*-
# Convert Markdown cheat sheets to HTML.
#
# You need:
#
# - rake (obviously)
# - RubyGems
# - the "kramdown" gem
#
# Otherwise, don't bother.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Defs
# ---------------------------------------------------------------------------

INDEX_PARTIAL = '_includes/index_partial.md'
INDEX_PARTIAL_TEMPLATE = '_layouts/index_partial.html.erb'

# How many columns to generate in the index file.
INDEX_COLUMNS = 3

# The minimum number of entries (cheat sheets) for columnar index output.
# Below this number, and we don't generate columns.
INDEX_COLUMN_THRESHOLD = INDEX_COLUMNS * 3

# The list of Markdown files to use to generate HTML.
MD_FILES = FileList['*.md'].exclude("README.md", "index.md")

# ---------------------------------------------------------------------------
# Tasks
# ---------------------------------------------------------------------------

task :default => [:jekyll]

task :jekyll => [:clean, INDEX_PARTIAL] do |t|
  sh 'jekyll'
end

task :index_partial => INDEX_PARTIAL

file INDEX_PARTIAL => MD_FILES + ['Rakefile', INDEX_PARTIAL_TEMPLATE] do |t|
  make_index_partial
  rm_f File.join("_site", "index.html")
end

desc "Build the site and run the local previewer on port 4000"
task :preview => :jekyll do
  sh 'jekyll', '--server'
end

desc "Clean up the generated stuff"
task :clean do
  rm_rf "_site"
end

# ---------------------------------------------------------------------------
# Support code
# ---------------------------------------------------------------------------

require 'rubygems'
require 'erb'

# Contains meta-information about a Markdown cheat sheet.
class CheatSheetSource
  attr_accessor :file

  def initialize(md_file)
    @file = md_file
    @title = nil
    @headers = nil
    @content = nil
  end

  def get_headers
    if @headers == nil
      @headers = {}
      # Drop the first --- line. Then, take everything up to the next --- line.
      lines = File.open(@file).readlines.
                               drop_while {|s| s =~ /^---*$/}.
                               take_while {|s| s !~ /^---*$/}
      lines.each do |line|
        if line =~ /^([^:]+):(.*)$/
          @headers[$1.strip] = $2.strip
        end
      end
    end

    @headers
  end

  def content
    if @content == nil
      # Drop the first --- line. Then, take everything after the next --- line
      @content = File.open(@file).readlines.
                                  drop_while {|s| s =~ /^---*$/}.
                                  drop_while {|s| s !~ /^---*$/}.
                                  drop(1)
    end
    @content
  end

  def title
    if @title == nil
      headers = get_headers
      @title = headers['title'] || File.basename(@file, '.md').chomp
    end
    @title
  end

  def label
    title.gsub(/\s*cheat sheet/i, '')
  end

  def basename
    File.basename(@file, '.md')
  end

  def html_file
    self.basename + ".html"
  end

  def to_s
    self.file
  end
end

# Behaves more or less like a readonly hash. Allows h.a, as well as h[a],
# for accessing values.
class CallableHash
  def initialize(h)
    @hash = h
    h.each do |k, v|
      self.class.send(:define_method, k, proc{self[k]})
    end
  end

  def [](k)
    @hash[k]
  end

  def get_binding
    binding()
  end
end

# Map the MD_FILES into CheatSheetSource objects.
MD_SOURCES = MD_FILES.to_a.map{|m| CheatSheetSource.new(m)}

def make_index_partial
  # Sort the list of sources by title.
  sources = MD_SOURCES.sort{|x,y| x.title.downcase <=> y.title.downcase}
  if sources.length > INDEX_COLUMN_THRESHOLD
    # Split into columns
    div_class = "multicolumn"
  else
    # Not enough for multi-column.
    div_class = ""
  end

  # Now, render.

  # safe_mode = 0 (default)
  # trim_mode = '>' (suppress newlines)
  erb = ERB.new(File.open(INDEX_PARTIAL_TEMPLATE).readlines.join(''), 0, '>')
  data = CallableHash.new(:sources => sources,
                          :div_class => div_class,
                          :title => 'Cheat Sheets')

  puts("Generating #{INDEX_PARTIAL} (via #{INDEX_PARTIAL_TEMPLATE})")
  File.open(INDEX_PARTIAL, 'w').write(erb.result(data.get_binding))
end
