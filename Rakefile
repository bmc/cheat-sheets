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

# HTML and templates subdirectories
HTML_DIR = "html"
TEMPLATE_DIR = "templates"

# Name of the generated index file.
INDEX_HTML = File.join(HTML_DIR, "index.html")

# Index HTML templates
INDEX_HTML_TEMPLATE = File.join(TEMPLATE_DIR, "index.html.erb")

# Cheat sheet HTML template
CHEAT_SHEET_HTML_TEMPLATE = File.join(TEMPLATE_DIR, "cheat-sheet.html.erb")

# The generated README.
README_HTML = File.join(HTML_DIR, "README.html")

# README HTML template
README_HTML_TEMPLATE = File.join(TEMPLATE_DIR, 'README.html.erb')

# How many columns to generate in the index file.
INDEX_COLUMNS = 3

# The minimum number of entries (cheat sheets) for columnar index output.
# Below this number, and we don't generate columns.
INDEX_COLUMN_THRESHOLD = INDEX_COLUMNS * 3

# The list of Markdown files to use to generate HTML.
MD_FILES = FileList['*.md'].exclude("README.md")

# The HTML output files.
HTML_FILES = MD_FILES.ext('html').gsub(/^/, "html/")

# ---------------------------------------------------------------------------
# Tasks
# ---------------------------------------------------------------------------

task :default => [INDEX_HTML, :html]

file INDEX_HTML => [HTML_FILES,
                    'Rakefile',
                    README_HTML,
                    CHEAT_SHEET_HTML_TEMPLATE,
                    INDEX_HTML_TEMPLATE].flatten do |t|
  make_index
end

file README_HTML => ['README.md', README_HTML_TEMPLATE] do |t|
  make_html_from_md(CheatSheetSource.new('README.md'),
                    README_HTML,
                    README_HTML_TEMPLATE)
end

task :html => HTML_FILES

# ---------------------------------------------------------------------------
# Rules
# ---------------------------------------------------------------------------

def html_to_md
  Proc.new {|task_name| task_name.sub(/^html./, '').sub(/\.html$/, '.md')}
end

# Complicated, but necessary. The target specifies the HTML file in the
# "html" subdirectory. The proc calculates the corresponding source file
# for the target. See http://rake.rubyforge.org/files/doc/rakefile_rdoc.html
# The proc is factored into html_to_md() for readability.

rule /^html\/.*\.html$/ => [html_to_md,
                            CHEAT_SHEET_HTML_TEMPLATE,
                            'Rakefile'] do |t|
  make_html_from_md(CheatSheetSource.new(t.source),
                    t.name,
                    CHEAT_SHEET_HTML_TEMPLATE)
end

# ---------------------------------------------------------------------------
# Support code
# ---------------------------------------------------------------------------

require 'rubygems'
require 'kramdown'
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
      lines = File.open(@file).readlines.drop_while {|s| s =~ /^\s*$/}
      if lines.length > 0
        if lines[0] =~ /^\#\s+(.*)/
          @headers[:title] = Regexp.last_match(1).strip
          @content = lines.drop(1)
        end
      end
    end
    @headers
  end

  def content
    if not @content
      @content = File.open(@file) do |f|
        f.readlines.drop_while {|s| s =~ /^\#\s+/}
      end
    end
    @content
  end

  def title
    if @title == nil
      headers = get_headers
      @title = headers[:title] || File.basename(@file, '.md').chomp
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

$template_cache = {}
def load_template(name)
  $template_cache[name] = File.open(name).readlines.join
end

def template(name)
  $template_cache[name] or load_template(name)
end

def expand_html(title, html, template_name)
  erb = ERB.new(template(template_name))
  erb.result(CallableHash.new(:title => title, :content => html).get_binding)
end

def make_html_from_md(source, target, template_name, title = nil)
  begin
    title = title || source.title
    puts "#{source} -> #{target} (via #{template_name})"
    content = Kramdown::Document.new(source.content.join).to_html
    File.open(target, 'w').write(expand_html(title, content, template_name))
  rescue
    $stderr.puts("*** Error making #{target}")
    raise $!
  end
end

def make_index
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
  erb = ERB.new(template(INDEX_HTML_TEMPLATE), 0, '>')
  data = CallableHash.new(:sources => sources,
                          :div_class => div_class,
                          :title => 'Cheat Sheets')

  puts("Generating #{INDEX_HTML} (via #{INDEX_HTML_TEMPLATE})")
  File.open(INDEX_HTML, 'w').write(erb.result(data.get_binding))
end
