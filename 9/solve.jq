#!/usr/bin/jq -Rnf

# usage: solve.jq --arg part 1 < input  # for part 1
# usage: solve.jq --arg part 2 < input  # for part 2


[ inputs ] | map(
    [
        split(" ") | map(tonumber) |
        if $part == "2" then
            reverse
        else
            .
        end
    ] |
    until(last | all(.==0);
        last as $last_array |
        . + [
            [range(last | length -1)] | map(
                    $last_array[.+1] - $last_array[.]
                )
            ]
    ) |
     map(last) | add
) | add
