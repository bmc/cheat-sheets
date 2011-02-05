title: Rake Cheat Sheet

## Rules

### Computing one or more dependencies

Example: You have a source file (e.g., Markdown) that, when converted,
produces an output file in an "html" subdirectory. The normal Rake `rule`
syntax doesn't support that. Instead, use a `proc` inside an array, to
calculate the name of the source file (dependency) from the target file.

    rule /^html\/.*\.html$/ => [
      proc { |task_name| task_name.sub(/^html./, '').sub(/\.html$/, '.md') }
    ] do |t|
        markdown(t.source, t.name)
    end
