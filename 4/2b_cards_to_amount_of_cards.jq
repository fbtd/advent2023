#!/usr/bin/jq -f

[
    .[] | {
        card_index: (.card - 1),
        amount_owned: 1,
        wins: [
            .winning as $winning |
            .numbers[] |
            select(IN($winning[]))
        ] | length
    }
] |
[
    foreach .[] as $card (
        .;

        .[$card.card_index].amount_owned as $amount_owned |
        .[:$card.card_index + 1] +
        (.[$card.card_index + 1 : $card.card_index + $card.wins +1] | map(.amount_owned += $amount_owned)) +
        .[$card.card_index + $card.wins +1:];

        .[$card.card_index].amount_owned
    )
] | add
