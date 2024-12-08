def pairs:
  [. as $l| range($l|length) | . as $i | range($i+1;$l|length) |[$l[$i],$l[.]] ];
def mid: .[(.|length)/2];
def diffs: [ .[0:-1], .[1:] ] | transpose | map (.[0]-.[1]);
def all_drop_one: [. as $l|range(0;(.|length)) as $i |($l|del(.[$i]))];
