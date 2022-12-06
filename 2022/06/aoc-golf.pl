perl -lnE 'sub r{$n=$_[0];$r="";for$x(1..$n){$r.="(.)";map{$r.="(?!".("."x($_-1))."\\$x)"}(1..$n-$x)};$r}$a=r(4);m!$a!;say"Part 1: $+[0]";$a=r(14);m!$a!;say"Part 2: $+[0]"' input.txt
