#!/usr/bin/jq -Rnf

def r(a; free_indices; remaining):
    if remaining > 0 then
        free_indices[] | . as $i | (a | .[$i] = "#") as $a | (free_indices | map(select(. != $i))) as $free_indices | r($a; $free_indices; remaining-1)
    else
        a
    end
;

1 as $PART |

[ inputs ] | map(
    split(" ") | { springs: .[0] | split(""), hints: .[1] | split(",") | map(tonumber) } |
    if $PART == 2 then
        .springs = .springs + ["?"] + .springs + ["?"] + .springs + ["?"] + .springs + ["?"] + .springs |
        .hints = .hints + .hints + .hints + .hints + .hints
    else . end |
    .additional_springs = (.hints | add) - (.springs | indices("#") | length) |
    . as $obj | debug |

    reduce 
    r(
            $obj.springs | map(select(. == "?") | ".");
            [range($obj.springs | map(select(. == "?")) | length)];
            $obj.additional_springs
    ) as $combination (0;
 #   . | ($combination | debug) as $_ |
    (
        reduce ($obj.springs | indices("?")[]) as $i ({possible_springs: $obj.springs, combination_i: 0};
            .possible_springs[$i] = $combination[.combination_i] |
            .combination_i += 1
        ) | .possible_springs | join("") | split(".") | map(select(. != "")) | map(length)
    ) as $hint |
    if $obj.hints == $hint then
        . += 1
    else . end
    ) | debug
) | add