#!/usr/bin/jq -Rnf

[ inputs ] |
(.[0] | split("")) as $directions |
.[2:] | map(capture("(?<pos>[A-Z]+) = \\((?<left>[A-Z]+), (?<right>[A-Z]+)\\)")) as $map |
$directions | length as $len |

{ pos: "AAA", i: 0} |
[
    while (.pos != "ZZZ";
        .pos as $here | .i as $i |
        .pos = (
            $map | .[] | select(.pos == $here ) |
            if $directions[$i % $len] == "L" then
                .left
            else
                .right
            end
        ) | .i += 1 | debug
    )
] | last | .i + 1