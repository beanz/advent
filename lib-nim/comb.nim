iterator choose*[T](a: openarray[T], n: int): seq[T] =
  var
    chosen = newSeqOfCap[T](n)
    i = 0
    i_stack = newSeqOfCap[int](n)
  while true:
    if chosen.len == n:
      yield chosen
      discard chosen.pop()
      i = i_stack.pop() + 1
    elif i != a.len:
      chosen.add(a[i])
      i_stack.add(i)
      inc i
    elif i_stack.len > 0:
      discard chosen.pop()
      i = i_stack.pop() + 1
    else:
      break
