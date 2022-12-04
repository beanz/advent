perl -lnE '@a=m!(\d+)!g;$A+=$a[0]>=$a[2]&&$a[1]<=$a[3]||$a[2]>=$a[0]&&$a[3]<=$a[1];$B+=!($a[0]>$a[3]||$a[2]>$a[1]);END{say"Part 1: $A\nPart 2: $B"}' ${1:-input.txt}
