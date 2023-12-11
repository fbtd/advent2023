#!/usr/bin/sed -f

1i\[

/^seeds: "/ 


s/^Card *\([[:digit:]]*\):/"card": \1, "numbers": \[/
s/\([[:digit:]][[:digit:]]*\)  *\([[:digit:]]\)/\1, \2/g
s/\([[:digit:]][[:digit:]]*\)  *\([[:digit:]]\)/\1, \2/g
s/|/\], "winning": \[/
s/$/\] \},/
s/^/\{/

$s/,$//
$a\]
