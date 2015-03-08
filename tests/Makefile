# Build the target `all' by default
default: tests

# Every target is passed to the parent's Makefile
%:
	cd .. && ${MAKE} $@

.PHONY: default
