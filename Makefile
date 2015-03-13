# If the first argument is "run", disable other given command line arguments
# (interpreted as targets) and give them as arguments to the program.
ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif# ocamlbuild variables

# ocamlbuild related 
OCBFLAGS := -classic-display
OCB := ocamlbuild $(OCBFLAGS)

# Files extensions
ML_EXT := ".ml"
CMA_EXT := ".cma"

# Directories
SRC_DIR := "src"
TESTS_DIR := "tests"

# Sources files
SRC_FILES := $(shell find $(SRC_DIR) -name "*$(ML_EXT)")
TESTS_FILES := $(shell find $(TESTS_DIR) -name "*$(ML_EXT)")
VERSION_FILE = $(SRC_DIR)/version.ml
DOC_FILE := hws.docdir/index.html

# Compiled files
SRC_CMA_FILES := $(SRC_FILES:.ml=.cma)
TESTS_CMA_FILES := $(TESTS_FILES:.ml=.cma)
VERSION_CMA_FILE = $(VERSION_FILE:.ml=.cma)

# Executables
SRC_EXE := $(SRC_DIR)/main.native
TESTS_EXE := $(TESTS_DIR)/tests.native

# Default target

all: build

# Compilation targets

build: $(SRC_EXE)

debug: $(SRC_CMA_FILES) $(TESTS_CMA_FILES) $(VERSION_CMA_FILE)

tests: $(TESTS_EXE)

doc: $(DOC_FILE)

# Launchers

run: $(SRC_EXE)
	@echo "================================================================"
	@echo
	@./`basename $<` $(RUN_ARGS) || true

runtests: $(TESTS_EXE)
	@echo "================================================================"
	@echo
	@./`basename $<` || true

viewdoc: $(DOC_FILE)
	xdg-open $(DOC_FILE)

top: debug
	utop

# Clean all this

clean:
	$(OCB) -clean
	$(RM) $(VERSION_FILE)*

# Files extension targets

%.cma:
	$(OCB) $@
%.cmxa:
	$(OCB) $@
%.native:
	$(OCB) $@
%.html:
	$(OCB) $@

.PHONY: all run tests runtests doc viewdoc debug clean top
