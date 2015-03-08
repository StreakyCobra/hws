OCBFLAGS := -classic-display
OCB := ocamlbuild $(OCBFLAGS)

SRC_FILES := $(shell find ./src/ -name "*.ml")
TESTS_FILES := $(shell find ./tests/ -name "*.ml")

SRC_CMA_FILES := $(SRC_FILES:.ml=.cma)
TESTS_CMA_FILES := $(TESTS_FILES:.ml=.cma)

MAIN_EXE := src/main.native
TESTS_EXE := tests/tests.native

DOC_FILE := hws.docdir/index.html
VERSION_FILE = src/version.ml

all: $(MAIN_EXE)

run:
	$(MAKE) all
	$(shell pwd)/$(shell basename $(MAIN_EXE))

tests: all $(TESTS_EXE)
	$(shell pwd)/$(shell basename $(TESTS_EXE))

doc: 
	$(OCB) $(DOC_FILE)

viewdoc: doc
	xdg-open $(DOC_FILE)

debug: all $(SRC_CMA_FILES) $(TESTS_CMA_FILES) $(VERSION_FILE:.ml=.cma)

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

.PHONY: all run tests doc viewdoc debug clean top
