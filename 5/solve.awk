#!/usr/bin/gawk -f
# usage: ./solve.awk part=1 < input
# usage: ./solve.awk part=2 < input


function follow_map(map, source) {
    for (entry_index in map) {
        if (source >= map[entry_index]["source"] && source <= map[entry_index]["source"] + map[entry_index]["range"]){
            delta = map[entry_index]["dest"] - map[entry_index]["source"]
            return source + delta
        }
    }
    return source
}


BEGIN {
    map_n = 0
}

/^seeds: / {
    sub("^seeds: ", "")
    i = 1
    while (i <= NF) {
        seed_paris[i][1] = $i
        if (part == 2) {
            seed_paris[i][2] = seed_paris[i][1] + $(i+1) -1
            i++
        } else {
            seed_paris[i][2] = seed_paris[i][1]
        }
        i++
    }
    next
}

/^$/ { next }

/map:$/ {
    map_n++
    i = 0   # index in almanac entry
    next
}

/^[0-9]/ {
    i++
    maps[map_n][i]["dest"]   = $1
    maps[map_n][i]["source"] = $2
    maps[map_n][i]["range"]  = $3
    next
}

END {
    lowest_location = -1
    for (seed_paris_index in seed_paris) {
        for (seed = seed_paris[seed_paris_index][1]; seed <= seed_paris[seed_paris_index][2]; seed++){
            if (seed % 10000000 == 0) { print "checking seed " seed }
            next_value = seed
            for (map_index in maps){
                next_value = follow_map(maps[map_index], next_value)
            }
            if (lowest_location == -1 || next_value < lowest_location ){
                lowest_location = next_value
            }
        }
    }
    print lowest_location
}

