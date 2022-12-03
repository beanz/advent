perl -lp0ne '@z=split//,"4830159072634801590267";s/(.) (.)/$k=(ord($1)-65)*4+ord($2)-88;$a+=$z[$k];$b+=$z[11+$k];/mge;$_="Part 1: $a\nPart 2: $b"' ${1:-input.txt}
