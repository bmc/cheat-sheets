STYLE_CSS_REF  = style.css
STYLE_CSS_FILE = html/$(STYLE_CSS_REF)

MD_FILES = $(wildcard *.md)
HTML_FILES = $(MD_FILES:%.md=html/%.html)

html/%.html: %.md Makefile $(STYLE_CSS_FILE)
	pandoc -c $(STYLE_CSS_REF) -s -f markdown -t html \
	--standalone -o $@ $<

all: $(HTML_FILES)
