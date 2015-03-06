OCBFLAGS := -classic-display
OCB := ocamlbuild $(OCBFLAGS)

ML_FILES := $(shell find ./src/ -name "*.ml")
CMA_FILES := $(ML_FILES:.ml=.cma)

all: src/main.native

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

.PHONY: all debug clean top
