#!/usr/bin/jq -Rnf

[ inputs ] | map(split(" ") | { springs: .[0] | split(""), hints: .[1] | split(",") | map(tonumber) })
