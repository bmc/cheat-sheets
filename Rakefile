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

# HTML templates
CHEAT_SHEET_TEMPLATE = File.join(HTML_DIR, "cheat-sheet-template.html")
INDEX_TEMPLATE = File.join(HTML_DIR, "index-template.html")
README_TEMPLATE = INDEX_TEMPLATE

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

INDEX_DEPS = [HTML_FILES, 'Rakefile', README_HTML, CHEAT_SHEET_TEMPLATE].flatten
file INDEX_HTML => INDEX_DEPS do |t|
    make_index
end

file README_HTML => ['README.md'] do |t|
    make_html_from_md(SourceFile.new('README.md'), README_HTML, README_TEMPLATE)
end

task :html => HTML_FILES

# ---------------------------------------------------------------------------
# Rules
# ---------------------------------------------------------------------------

# Complicated, but necessary. The target specifies the HTML file in the
# "html" subdirectory. The proc calculates the corresponding source file
# for the target. See http://rake.rubyforge.org/files/doc/rakefile_rdoc.html

rule /^html\/.*\.html$/ => [
  proc { |task_name| task_name.sub(/^html./, '').sub(/\.html$/, '.md') },
  CHEAT_SHEET_TEMPLATE
] do |t|

    make_html_from_md(SourceFile.new(t.source), t.name, CHEAT_SHEET_TEMPLATE)
end

# ---------------------------------------------------------------------------
# Support code
# ---------------------------------------------------------------------------

require 'rubygems'
require 'kramdown'

# Contains meta-information about a Markdown cheat sheet.
class SourceFile
    attr_accessor :file

    def initialize(md_file)
        @file = md_file
        @title = nil
        @headers = nil
    end

    def get_headers
        if @headers == nil
            @headers = {}
            File.open(@file) do |f|
                f.readlines.take_while {|s| s =~ /^[A-Za-z]+:/}
            end.select {|s| s != nil}.map {|s| s.strip}.each do |h|
                /^(.*):(.*)$/ =~ h
                header = Regexp.last_match(1).strip
                value = Regexp.last_match(2).strip
                @headers[header] = value
            end
        end
        @headers
    end

    def content
        File.open(@file) do |f|
            f.readlines.drop_while {|s| s =~ /^[A-Za-z]+:/}
        end
    end

    def title
        if @title == nil
            headers = get_headers
            @title = headers['title'] || File.basename(@file, '.md').chomp
        end
        @title
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

# Map the MD_FILES into SourceFile objects.
MD_SOURCES = MD_FILES.to_a.map{|m| SourceFile.new(m)}

$template_cache = {}
def load_template(name)
    $template_cache[name] = File.open(name).readlines
end

def template(name)
    $template_cache[name] or load_template(name)
end

def expand_html(title, html, template_name)
    template(template_name).map do |line|
        line.gsub('{{title}}', title).
             gsub('{{content}}', html)
    end.join('')
end

def make_html_from_md(source, target, template_name, title = nil)
    title = title || source.title
    puts "#{source} -> #{target} (via #{template_name})"
    make_html(source.content.join,
              target, title, template_name)
end

def make_html(markdown_content, target, title, template_name)
    begin
        content = Kramdown::Document.new(markdown_content).to_html
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

    markdown = ['# Cheat Sheets',
                '',
                '[README (with disclaimer)](README.html)',
                '',
                "<div class='#{div_class}' markdown='1'>"]

    sources.each do |md_source|
        title = md_source.title.gsub(/cheat sheet/i, '').strip
        base = File.basename(md_source.file, '.md')
        html_file = base + '.html'
        markdown << "* [#{title}](#{html_file}) (#{base})"

    end

    markdown << '</div>'

    puts("Generating #{INDEX_HTML}")
    make_html(markdown.join("\n"), INDEX_HTML, 'Cheat Sheets', INDEX_TEMPLATE)
end
