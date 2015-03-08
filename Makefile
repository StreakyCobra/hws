OCBFLAGS := -classic-display
OCB := ocamlbuild $(OCBFLAGS)

ML_FILES := $(shell find ./src/ -name "*.ml")
CMA_FILES := $(ML_FILES:.ml=.cma)

EXE_FILE := src/main.native
DOC_FILE := hws.docdir/index.html

all: $(EXE_FILE)

run:
	@$(MAKE) all
	$(shell pwd)/$(shell basename $(EXE_FILE))

doc: 
	$(OCB) $(DOC_FILE)

viewdoc: doc
	xdg-open $(DOC_FILE)

debug: all $(CMA_FILES)

clean:
	$(OCB) -clean
	$(RM) src/version.ml*

top: debug
	utop

%.cma:
	$(OCB) $@
%.cmxa:
	$(OCB) $@
%.native:
	$(OCB) $@

.PHONY: all run doc viewdoc debug clean top
