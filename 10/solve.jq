#!/usr/bin/jq -Rnf

# usage: solve.jq --arg part 1 < input  # for part 1
# usage: solve.jq --arg part 2 < input  # for part 2

def find(cond; len):
    def _find:
        if cond then
            .
        else
            if .x == len then
                .x = 0 | .y += 1
            else
                .x += 1
            end | _find
        end
    ;
    { "x": 0, "y": 0} | _find
;

{
    "|": [[-1,0],[1,0]],
    "-": [[0,-1],[0,1]],
    "L": [[-1,0],[0,1]],
    "J": [[-1,0],[0,-1]],
    "7": [[1,0],[0,-1]],
    "F": [[1,0],[0,1]],
} as $legend |


[ inputs ] | map(split("")) |
length as $rows | (first | length) as $len | . as $pipes |
find($pipes[.x][.y] == "S"; $len) as $start | $start |

if ($pipes[.x+1][.y] | IN("|", "L", "J")) and .x+1 < $rows then .x+=1
elif ($pipes[.x][.y+1] | IN("L", "-", "F")) and .y+1 < $len then .y+=1
else .y-=1
end | {prev: $start, this: ., steps: 1, main_pipe: [$start, .]} |

until(.this == $start;
    $pipes[.this.x][.this.y] as $type |
    .next = {x: (.this.x + ( $legend | getpath([$type])[0][0])), y: (.this.y + ( $legend | getpath([$type])[0][1]))} |
    if .next == .prev then
        .next = {x: (.this.x + ( $legend | getpath([$type])[1][0])), y: (.this.y + ( $legend | getpath([$type])[1][1]))}
    else
        . 
    end |
    .prev = .this | .this = .next | .main_pipe += [.this] |
    .steps += 1
) | (.steps / 2 | debug) as $_ |

# part 2
.main_pipe as $main_pipe |
[
    range($rows) as $x |
    ([
        foreach range($len) as $y ({pipes_crossed: 0, northbound: false, count: 0};
            ($main_pipe | index({x: $x, y: $y}) != null) as $is_pipe | .y = $y |
            if ($is_pipe | not) then
                if .pipes_crossed % 2 == 1 then
                    .count += 1
                else
                    .
                end | .
            elif ($pipes[$x][$y] == "J") and .northbound then
                .pipes_crossed += 1
            elif ($pipes[$x][$y] == "7") and (.northbound == false) then
                .pipes_crossed += 1
            elif $pipes[$x][$y] == "|" then
                .pipes_crossed += 1
            elif ($pipes[$x][$y] == "F") then
                .northbound = true
            elif ($pipes[$x][$y] == "L") then
                .northbound = false
            else
                .
            end;

            .count
        )
    ]| last)
] | add

