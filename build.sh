#!/bin/sh

exitcode=0

if [ $# -eq 0 ]; then
  days=$(seq -w 1 25)
else
  days=$@
fi

for i in $days; do
  if [ ! -f day$i*.d ]; then
    echo "$i not implemented"
    continue
  fi

  if ! dub build --single -b release day$i*.d; then
    exitcode=1
  fi
done

exit $exitcode
