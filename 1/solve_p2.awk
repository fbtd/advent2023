#!/usr/bin/gawk -f


BEGIN {
    FS = ""
    total = 0 
}

{
    gsub(/one/,   "o1e")
    gsub(/two/,   "t2o")
    gsub(/three/, "t3e")
    gsub(/four/,  "4")
    gsub(/five/,  "5e")
    gsub(/six/,   "6")
    gsub(/seven/, "7n")
    gsub(/eight/, "e8t")
    gsub(/nine/,  "9e")
    gsub(/zero/,  "0o")

    gsub(/eleven/,  11)
    gsub(/twelve/,  12)
    gsub(/teen/,  "")

    gsub(/[^0-9]/, "")
    total += $1 * 10 + $NF
}

END { print total }
