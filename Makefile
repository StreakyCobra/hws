OCBFLAGS := -classic-display
OCB := ocamlbuild $(OCBFLAGS)

all: src/main.native

debug: all src/main.cma

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
