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

# HTML subdir
HTML_DIR = "html"

# Name of the generated index file.
INDEX_HTML = File.join(HTML_DIR, "index.html")

# How many columns to generate in the index file.
INDEX_COLUMNS = 3

# HTML template
HTML_TEMPLATE = File.join(HTML_DIR, "template.html")

# The minimum number of entries (cheat sheets) for columnar index output.
# Below this number, and we don't generate columns.
INDEX_COLUMN_THRESHOLD = INDEX_COLUMNS * 3

# The generated README.
README_HTML = File.join(HTML_DIR, "README.html")

# The list of Markdown files to use to generate HTML.
MD_FILES = FileList['*.md'].exclude("README.md")

# The HTML files.
HTML_FILES = MD_FILES.ext('html').gsub(/^/, "html/")

# ---------------------------------------------------------------------------
# Tasks
# ---------------------------------------------------------------------------

task :default => [INDEX_HTML, :html]

INDEX_DEPS = [HTML_FILES, 'Rakefile', README_HTML].flatten
file INDEX_HTML => INDEX_DEPS do |t|
    make_index
end

file README_HTML => ['README.md'] do |t|
    make_html_from_md(SourceFile.new('README.md'), README_HTML)
end

task :html => HTML_FILES

# ---------------------------------------------------------------------------
# Rules
# ---------------------------------------------------------------------------

# Complicated, but necessary. The target specifies the HTML file in the
# "html" subdirectory. The proc calculates the corresponding source file
# for the target. See http://rake.rubyforge.org/files/doc/rakefile_rdoc.html

rule /^html\/.*\.html$/ => [
  proc { |task_name| task_name.sub(/^html./, '').sub(/\.html$/, '.md') }
] do |t|

    puts "#{t.source} -> #{t.name}"
    make_html_from_md(SourceFile.new(t.source), t.name)
end

# ---------------------------------------------------------------------------
# Support code
# ---------------------------------------------------------------------------

require 'rubygems'
require 'kramdown'

# Contains meta-information about a Markdown cheat sheet.
class SourceFile
    attr_accessor :file, :title

    def initialize(md_file)
        @file = md_file
        @title = title_for(md_file)
    end

    def title_for(md)
        headers = File.open(@file) do |f|
            f.readlines.select {|s| (s =~ /^# .*$/) != nil}.map {|s| s[2..-1]}
        end.select {|s| s != nil}.map {|s| s.gsub(/cheat sheet/i, '').strip}

        (headers[0] || File.basename(md, '.md')).chomp
    end

    def basename
        File.basename(@file, '.md')
    end

    def html_file
        self.basename + ".html"
    end

    def to_s
        #self.file
        self.inspect
    end
end

# Map the MD_FILES into SourceFile objects.
MD_SOURCES = MD_FILES.to_a.map{|m| SourceFile.new(m)}

$html_template = nil
def template(name)
    if $html_template == nil
        $html_template = File.open(HTML_TEMPLATE).readlines
    end
    $html_template
end

def expand_html(title, html)
    template('template').map do |line|
        line.gsub('{{title}}', title).
             gsub('{{content}}', html)
    end.join('')
end


def make_html_from_md(source, target, title = nil)
    title = title || source.title
    make_html(File.open(source.file).readlines.join, target, title)
end

def make_html(markdown_content, target, title)
    begin
        k = Kramdown::Document.new(markdown_content)
        File.open(target, 'w').write(expand_html(title, k.to_html))
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

        total_per = sources.length / INDEX_COLUMNS
        rem = sources.length % INDEX_COLUMNS

        # Initially, each column is the same length. Records these lengths
        # in an n-element array.
        totals = (1..INDEX_COLUMNS).map {total_per}

        # Now, bump up the leading columns by one, for each remainder.
        (0..rem-1).each {|i| totals[i] += 1 }

        # Create an n-element array of arrays. Each subarray contains the
        # list of cheat sheets for one column.
        md = sources
        files = []
        totals.each do |t|
            files << md.take(t)
            md = md.drop(t)
        end
    else
        # Not enough for multi-column. Use an array of one array.

        files = [sources]
    end

    # Now, render.

    markdown = ['# Cheat Sheets',
                '',
                '[README (with disclaimer)](README.html)',
                '',
                '<table border="0">',
                '<tr valign="top">']

    files.each do |array|
        markdown << '<td align="left" markdown="1">'

        array.each do |md_source|
            title = md_source.title
            base = File.basename(md_source.file, '.md')
            html_file = base + '.html'
            markdown << "* [#{title}](#{html_file}) (#{base})"

        end

        markdown << '</td>'
    end

    markdown << '</tr>'
    markdown << '</table>'

    puts("Generating #{INDEX_HTML}")
    make_html(markdown.join("\n"), INDEX_HTML, 'Cheat Sheets')
end
