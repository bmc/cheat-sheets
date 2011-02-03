STYLE_CSS_REF  = style.css
STYLE_CSS_FILE = html/$(STYLE_CSS_REF)

# Different extension, to avoid circular reference.
INDEX_MARKDOWN = html/index.markdown
INDEX_HTML     = html/index.html

MD_FILES = $(wildcard *.md)
ALL_FILES = $(wildcard *)
NON_MD_FILES = $(filter-out $(MD_FILES) Makefile,$(ALL_FILES))
MD_BASENAMES = $(MD_FILES:%.md=%)
HTML_FILES = $(MD_FILES:%.md=html/%.html) html/index.html

html/%.html: %.md Makefile $(STYLE_CSS_FILE)
	pandoc -c $(STYLE_CSS_REF) -s -f markdown -t html \
	--standalone -o $@ $<

html/%.html: html/%.markdown Makefile $(STYLE_CSS_FILE)
	pandoc -c $(STYLE_CSS_REF) -s -f markdown -t html \
	--standalone -o $@ $<

all: $(HTML_FILES) $(INDEX_HTML)
other:
	@echo $(NON_MD_FILES)

$(INDEX_MARKDOWN): $(MD_FILES) Makefile
	@(\
	 echo '# Cheat Sheets';\
	 echo '';\
	 for i in $(MD_BASENAMES); do\
	     echo "* [$$i]($$i.html)";\
	 done;\
	 echo '';\
	 echo '# Non-HTML Sheets';\
	 echo '';\
	 for i in $(NON_MD_FILES); do\
	     if [ -f $$i ]; then\
	         echo "* [$$i](../$$i)";\
	     fi;\
	 done\
	) >$(INDEX_MARKDOWN)
