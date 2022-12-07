perl -lE '@l=<>;for(@l){$t+=$1 if/(\d+)/}$m=7e7;$n=3e7-($m-$t);shift@l;sub d{my$c=0;while($_=shift@l){if(/^(\d+)/){$c+=$1;}elsif(/\.\.$/){return$c}elsif(/^. c/){$s=d();$P+=$s if($s<1e5);$m=$s if($s<$m&&$s>$n);$c+=$s}}return$c}d();say"Part 1: $P\nPart 2: $m";' ${1:-input.txt}

