#!/usr/bin/sed -f

1i\[

s/^\([A-Z0-9]*\) \([0-9]*\)$/   {"hand": "\1", "bet": \2},/

$s/,$//
$a\]