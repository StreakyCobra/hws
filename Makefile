OCBFLAGS := -classic-display
OCB := ocamlbuild $(OCBFLAGS)

ML_FILES := $(shell find ./src/ -name "*.ml")
CMA_FILES := $(ML_FILES:.ml=.cma)

EXE_FILE := src/main.native
DOC_FILE := hws.docdir/index.html
VERSION_FILE = src/version.ml

all: $(EXE_FILE)

run:
	@$(MAKE) all
	$(shell pwd)/$(shell basename $(EXE_FILE))

doc: 
	$(OCB) $(DOC_FILE)

viewdoc: doc
	xdg-open $(DOC_FILE)

debug: all $(VERSION_FILE:.ml=.cma)

clean:
	$(OCB) -clean
	$(RM) $(VERSION_FILE)*

top: debug
	utop

%.cma:
	$(OCB) $@
%.cmxa:
	$(OCB) $@
%.native:
	$(OCB) $@

.PHONY: all run doc viewdoc debug clean top
