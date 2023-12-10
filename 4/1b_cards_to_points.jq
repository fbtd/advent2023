#!/usr/bin/jq -f

[
    .[] | [
        .winning as $winning |
        .numbers[] |
        select(IN($winning[]))
        ] | length | select(. > 0) | pow(2; .-1)
] | add