perl -lne '@s=qw/one two three four five six seven eight nine/;for(1..9){$n{$s[$_-1]}=$n{$_}=$_};$p="(".(join"|",keys%n).")";/^.*?$p/;$c+=10*$n{$1};/^.*$p/;$c+=$n{$1};/^.*?(\d)/;$b+=10*$1;/^.*(\d)/;$b+=$1;END{print "Part 1: $b\nPart 2: $c"}' "$@"

