#!/usr/bin/jq -Rnf

1000000 as $EXPANSION_RATE |

def abs: if . < 0 then . *= -1 else . end;

[ inputs ] | map(split("")) | (first | length) as $row_len | length as $rows | . as $space |
flatten | indices("#") as $galaxies | . as $flat_space |

(   reduce range($rows) as $row ([];
        if [range($row * $row_len; ($row +1) * $row_len) | select($flat_space[.] == "#")] | length == 0 then
            . += [$row]
        else . end
))  as $double_rows |

(   reduce range($row_len) as $column ([];
        if [range($column; $row_len * $rows; $row_len) | select($flat_space[.] == "#")] | length == 0 then
            . += [$column]
        else . end
))  as $double_columns |

reduce ([$galaxies | combinations(2) | sort] | unique[] ) as $pair (0;
    ([0, 1] | map($pair[.] % $row_len) | sort) as $x_shift |
    ($double_columns | map(select($x_shift[0] < . and $x_shift[1] > .)) | length) as $x_expansion |

    ([0, 1] | map($pair[.] / $rows | floor) | sort) as $y_shift |
    ($double_rows | map(select($y_shift[0] < . and $y_shift[1] > .)) | length) as $y_expansion |

    . + $x_shift[1] - $x_shift[0] + $x_expansion * ($EXPANSION_RATE-1) 
      + $y_shift[1] - $y_shift[0] + $y_expansion * ($EXPANSION_RATE-1)
)