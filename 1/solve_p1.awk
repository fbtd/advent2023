#!/usr/bin/gawk -f


BEGIN {
    FS = ""
    total = 0 
}

{
    gsub(/[^0-9]/, "")
    total += $1 * 10 + $NF
}

END { print total }