#!/usr/bin/gawk -f



function quadratic_1(a, b, c) {
    return (-b +(b**2 -4*a*c)**.5)/(2*a)
}

function quadratic_2(a, b, c) {
    return (-b -(b**2 -4*a*c)**.5)/(2*a)
}

/^Time:/ {
    split($0, times, " ")
    end = NF
}
/^Distance:/ { split($0, distances, " ") }

END {
    i = 2
    tot_valid = 1
    while (i <= NF ) {
        first_valid = quadratic_1(-1,times[i],distances[i] * -1)
        first_valid = int(first_valid + 1)

        last_valid = quadratic_2(-1,times[i],distances[i] * -1)
        if ( last_valid % 1 == 0 ) { last_valid-- }
        last_valid = int(last_valid)

        n_valid = last_valid - first_valid + 1

        tot_valid *= n_valid
        i++
    }
    print tot_valid
}