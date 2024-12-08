def pairs:
  [. as $l| range($l|length) | . as $i | range($i+1;$l|length) |[$l[$i],$l[.]] ];
