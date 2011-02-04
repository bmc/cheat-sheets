#                                                                -*- ruby -*-
# Convert Markdown cheat sheets to HTML.
#
# You need RubyGems, rake (obviously), and the kramdown gem, or don't bother.
# ---------------------------------------------------------------------------

require 'rubygems'
require 'kramdown'

# ---------------------------------------------------------------------------
# Defs
# ---------------------------------------------------------------------------

INDEX_MARKDOWN = "html/index.markdown"
INDEX_HTML = "html/index.html"
README_HTML = "html/README.html"
MD_FILES = FileList['*.md'].exclude("README.md")
HTML_FILES = MD_FILES.ext('html').gsub(/^/, "html/")

# ---------------------------------------------------------------------------
# Tasks
# ---------------------------------------------------------------------------

task :default => [INDEX_HTML, :html]

file INDEX_HTML => HTML_FILES + ['Rakefile', README_HTML] do |t|
    make_index
end

file README_HTML => ['README.md'] do |t|
    make_html_from_md('README.md', README_HTML)
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
    make_html_from_md(t.source, t.name)
end

# ---------------------------------------------------------------------------
# Support code
# ---------------------------------------------------------------------------

$html_template = nil

def html_template
    if ! $html_template
        $html_template = File.open('html/template.html').readlines
    end
    $html_template
end

def expand_html(title, html)
    html_template.map do |line|
        line.gsub('{{title}}', title).
             gsub('{{content}}', html)
    end
end

def title_for(md)
    headers = File.open(md) do |f|
        f.readlines.select {|s| (s =~ /^# .*$/) != nil}.map {|s| s[2..-1]}
    end.select {|s| s != nil}

    (headers[0] || File.basename(md, '.md')).chomp
end

def make_html_from_md(source, target, title = nil)
    title = title || title_for(source)
    make_html(File.open(source).readlines.join, target, title)
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
    markdown = ['# Cheat Sheets',
                '',
                '[README (with disclaimer)](README.html)',
                '']

    MD_FILES.each do |md|
        title = title_for(md)
        base = File.basename(md, '.md')
        html = base + '.html'
        markdown << "* [#{title}](#{html}) (#{base})"
    end

    index = 'html/index.html'
    puts("Generating #{index}")
    make_html(markdown.join("\n"), index, "Cheat Sheets")
end
