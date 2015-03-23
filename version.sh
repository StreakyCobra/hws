cat myocamlbuild.ml \
  | grep -e '^let \(major\|minor\|patch\)' \
  | cut -f2 -d= \
  | tr "\\n" "." \
  | tr -d " " \
  | sed 's/\.$/\n/g'
