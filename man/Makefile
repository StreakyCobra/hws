# Use bash
SHELL           := /bin/bash

# Get version number
VERSION         := $(shell cd ..; ./version.sh)

# Parameters
DOC_FILES       := $(wildcard *.[0-9].adoc)
MAN_FILES       := $(DOC_FILES:.adoc=)
HTML_FILES      := $(DOC_FILES:.adoc=.html)
HTML_INDEX      := hws.1.html
ASCIIDOC_CONF   := asciidoc.conf
ASCIIDOC_OPTS   := -f $(ASCIIDOC_CONF) \
                   -a hws_version=$(VERSION)

# Targets
all: $(MAN_FILES) $(HTML_FILES)

clean:
	rm -rf $(MAN_FILES)
	rm -rf $(HTML_FILES)

viewman: $(HTML_FILES)
	xdg-open $(HTML_INDEX)

# Files
$(MAN_FILES): $(DOC_FILES) $(ASCIIDOC_CONF)
	a2x --doctype manpage --format manpage --asciidoc-opts="$(ASCIIDOC_OPTS)" $@.adoc

$(HTML_FILES): $(DOC_FILES) $(ASCIIDOC_CONF)
	asciidoc $(ASCIIDOC_OPTS) $(@:.html=.adoc)

.PHONY: all clean viewdoc
