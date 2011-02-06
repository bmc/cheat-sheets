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
CHEAT_SHEET_TEMPLATE = File.join(HTML_DIR, "cheat-sheet.html.erb")
INDEX_TEMPLATE = File.join(HTML_DIR, "index.html.erb")
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

INDEX_DEPS = [HTML_FILES,
              'Rakefile',
              README_HTML,
              CHEAT_SHEET_TEMPLATE,
              INDEX_TEMPLATE].flatten
file INDEX_HTML => INDEX_DEPS do |t|
    make_index
end

file README_HTML => ['README.md', README_TEMPLATE] do |t|
    make_html_from_md(SourceFile.new('README.md'), README_HTML, README_TEMPLATE)
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

rule /^html\/.*\.html$/ => [html_to_md, CHEAT_SHEET_TEMPLATE, 'Rakefile'] do |t|
    make_html_from_md(SourceFile.new(t.source), t.name, CHEAT_SHEET_TEMPLATE)
end

# ---------------------------------------------------------------------------
# Support code
# ---------------------------------------------------------------------------

require 'rubygems'
require 'kramdown'
require 'erb'

# Contains meta-information about a Markdown cheat sheet.
class SourceFile
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

class TemplateData
    attr_accessor :title, :content

    def initialize(title, content)
        @title = title
        @content = content
    end

    def get_binding
        binding()
    end
end

# Map the MD_FILES into SourceFile objects.
MD_SOURCES = MD_FILES.to_a.map{|m| SourceFile.new(m)}

$template_cache = {}
def load_template(name)
    $template_cache[name] = ERB.new(File.open(name).readlines.join)
end

def template(name)
    $template_cache[name] or load_template(name)
end

def expand_html(title, html, template_name)
    erb = template(template_name)
    erb.result(TemplateData.new(title, html).get_binding)
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

    puts("Generating #{INDEX_HTML} (via #{INDEX_TEMPLATE})")
    make_html(markdown.join("\n"), INDEX_HTML, 'Cheat Sheets', INDEX_TEMPLATE)
end
