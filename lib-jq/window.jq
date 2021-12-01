# https://gist.github.com/connesc/d6b87cbacae13d4fd58763724049da58
def window(values; $size; $step):
  def checkparam(name; value): if (value | isnormal) and value > 0 and (value | floor) == value then . else error("window \(name) must be a positive integer") end;
  checkparam("size"; $size)
| checkparam("step"; $step)
  # We need to detect the end of the loop in order to produce the terminal partial group (if any).
  # For that purpose, we introduce an artificial null sentinel, and wrap the input values into singleton arrays in order to distinguish them.
| foreach ((values | [.]), null) as $item (
    {index: -1, items: [], ready: false};
    (.index + 1) as $index
    # Extract items that must be reused from the previous iteration
    | if (.ready | not) then .items
      elif $step >= $size or $item == null then []
      else .items[-($size - $step):]
      end
    # Append the current item unless it must be skipped
    | if ($index % $step) < $size then . + $item
      else .
      end
    | {$index, items: ., ready: (length == $size or ($item == null and length > 0))};
    if .ready then .items else empty end
  );
