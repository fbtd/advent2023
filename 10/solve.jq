#!/usr/bin/jq -Rnf

# usage: solve.jq --arg part 1 < input  # for part 1
# usage: solve.jq --arg part 2 < input  # for part 2


{
    "|": [[0,-1],[0,1]],
    "-": [[-1,0],[1,0]],
    "L": [[0,-1],[1,0]],
    "J": [[0,-1],[-1,0]],
    "7": [[0,1],[-1,0]],
    "F": [[0,1],[0,1]],
} as $legend |


[ inputs ] |map(split("")) |
length as $rows | (first | length) as $len | . as $pipes |
(
    false as $found | 0 as $y | 0 as $x |
    until(.[$x][$y] == "S";
        if $y == $len then
            ($x + 1) as $x |
            0 as $y | debug | .
        else
            ($y | debug) as $_ |
            ($y + 1) as $y | 
            ($y | debug) as $_ | .
        end
    )
) as $start | $start