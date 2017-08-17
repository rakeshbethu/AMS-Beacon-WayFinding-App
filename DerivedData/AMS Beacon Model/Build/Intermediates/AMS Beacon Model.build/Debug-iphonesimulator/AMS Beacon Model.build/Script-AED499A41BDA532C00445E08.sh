#!/bin/sh
tags="TODO:"
matches=`find "${SRCROOT}" \( -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($tags).*\$"`
echo "$matches" | perl -p -e "s/($tags)/ error: \$1/"
[ -z "$matches" ] || exit 1
