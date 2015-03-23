#!/usr/bin/env bash
#
# Returns the version number in the form:
#
#   MAJOR.MINOR.PATCH
#
# from the version declared in the «myocamlbuild.ml» file. It permits to get the
# version number from scripts and Makefiles by keeping the version number stored
# in one central place.

cat myocamlbuild.ml \
  | grep -e '^let \(major\|minor\|patch\)' \
  | cut -f2 -d= \
  | tr "\\n" "." \
  | tr -d " " \
  | sed 's/\.$/\n/g'
