OCBFLAGS := -classic-display
OCB := ocamlbuild $(OCBFLAGS)

ML_FILES := $(shell find ./src/ -name "*.ml")
CMA_FILES := $(ML_FILES:.ml=.cma)

all: src/main.native

doc: hws.docdir/index.html

viewdoc: hws.docdir/index.html
	xdg-open $<

debug: all $(CMA_FILES)

clean:
	$(OCB) -clean
	$(RM) src/version.ml*

top: debug
	utop

hws.docdir/index.html:
	$(OCB) $@
%.cma:
	$(OCB) $@
%.cmxa:
	$(OCB) $@
%.native:
	$(OCB) $@

.PHONY: all doc viewdoc debug clean top
