def sparse_map:
  split("\n")[:-1] | {
   h: (.|length),
   w: (.[0]|length),
   m:(
    to_entries
    | map(.key as $y|
          (.value
           |split("")
           |to_entries 
           |map([.value, .key, $y])
           |map(select((.[0] == ".")|not))
          )
         )
    |flatten(1))
  };
def dense_map:
  split("\n")[:-1] | {
   h: (.|length),
   w: (.[0]|length),
   m: map(split(""))
  };
def bounds($w; $h; $x; $y):
  (0 <= $x and $x < $w and 0 <= $y and $y < $h);
def in_bound($m; $x; $y):
  (0 <= $x and $x < $m.w and 0 <= $y and $y < $m.h);
def ch_at($m;$x;$y): $m.m[$y][$x];
def ch_in_bound($m;$x;$y):
  if in_bound($m; $x; $y) then
    $m.m[$y][$x]
  else
    null
  end;
def find_aux($m;$ch;$y):
  if $y > ($m.m|length) then
    "failed to find \($ch) in map" | error
  else
    ($m.m[$y] | index($ch)) as $i |
    if $i then
      [$i,$y]
    else
      find_aux($m;$ch;$y+1)
    end
  end;
def find($m;$ch): find_aux($m;$ch;0);
def bounds($w; $h; $x; $y):
  (0 <= $x and $x < $w and 0 <= $y and $y < $h);
