#!/usr/bin/env bash
#
# Return the version number in the form:
#
#   MAJOR.MINOR.PATCH
#
# from the version declared in the «myocamlbuild.ml» file. It permits to get the
# version number from scripts and Makefiles.

cat myocamlbuild.ml \
  | grep -e '^let \(major\|minor\|patch\)' \
  | cut -f2 -d= \
  | tr "\\n" "." \
  | tr -d " " \
  | sed 's/\.$/\n/g'
