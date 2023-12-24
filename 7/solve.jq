#!/usr/bin/jq -f

# usage: solve.jq < input               # for part 1
# usage: solve.jq --arg part 2 < input  # for part 2

(
    if $part == "2" then
        {A: 14, K: 13, Q: 12, J: 1, T: 10}
    else
        {A: 14, K: 13, Q: 12, J: 11, T: 10}
    end
) as $LABELS |

15 as $CARD_MUL |
759375 as $WORTH_MUL |


def promote_jokers:
    . as $in |
    reduce .[] as $card (
        {};
        setpath([$card]; getpath([$card]) +1)
    ) | # ["DEBUG:",{"A":1,"J":1,"Q":3}]
    if .J < 5 then
        delpaths([["J"]]) 
    else
        .
    end |
    to_entries | map(.card_value = (
        if .key | in($LABELS) then
            .key as $k| $LABELS | getpath([$k])
        else
            .key | tonumber
        end
                # quantity
    )) | sort_by(.value, .card_value) | last | .key as $new_joker |

    $in | map(
        if . == "J" then
            $new_joker
        else
            .
        end
    )
;

def hand_to_value:
    split("") | . as $original_hand |

    if $part == "2" then
        . | promote_jokers 
    else
        .
    end |
    sort | join("") |

    {t: ., worth: 0} |
    if .t | test("(.)\\1\\1\\1\\1") then                            # five of a kind
        .worth += 6
    elif .t | test("(.)\\1\\1\\1") then                             # four of a kind
        .worth += 5
    elif .t | test("((.)\\2\\2(.)\\3)|((.)\\5(.)\\6\\6)") then      # full house
        .worth += 4
    elif .t | test("(.)\\1\\1") then                                # three of a kind
        .worth += 3
    elif .t | test("(.)\\1.?(.)\\2") then                           # two pairs
        .worth += 2
    elif .t | test("(.)\\1") then                                   # one pair
        .worth += 1
    else
        .
    end |
    .worth *= $WORTH_MUL |
    .worth += (
        reduce $original_hand[] as $card (
            {value: 0, i:0};
            .value *= $CARD_MUL |
            .value += (
                if $card | in($LABELS) then
                    $LABELS | getpath([$card])
                else
                    $card | tonumber
                end
            ) |
            .i += 1
        )
        | .value
    ) | .worth
;

[
    .[] | .worth = (.hand | hand_to_value)
] |
sort_by(.worth) | reduce .[] as $hand (
    {sum: 0, i: 1};
    .sum += $hand.bet * .i |
    .i += 1
) | .sum