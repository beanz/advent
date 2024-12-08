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
def bounds($w; $h; $x; $y):
  (0 <= $x and $x < $w and 0 <= $y and $y < $h);
