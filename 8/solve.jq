#!/usr/bin/jq -Rnf

(
    if $part == "1" then
        . | {start: ["AAA"], end:"ZZZ"}
    elif $part == "e2" then
        . | {start: ["11A","22A"], end:"Z"}
    else
        . | {start: ["AAA","PRA","PVA","XLA","PTA","FBA"], end:"Z"}
    end
) as $patters |

[ inputs ] |
(.[0] | split("")) as $directions |
.[2:] | map(capture("(?<pos>[0-9A-Z]+) = \\((?<left>[0-9A-Z]+), (?<right>[0-9A-Z]+)\\)")) as $places |
$directions | length as $len |

{ here: $patters.start, i: 0} |
[
    while ( 
         .here | map(endswith($patters.end)) | map(not) | any;

        .here as $here | .i as $i | 
        .here = (
            $places | map(select(.pos as $pos | $here | index($pos))) |

            if $directions[$i % $len] == "L" then
                map(.left)
            else
                map(.right)
            end
        ) | .i += 1 | debug
    )
] | last | .i + 1