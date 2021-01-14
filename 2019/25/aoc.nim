import aoclib, intcode, comb

proc part1(prog: seq[int64]): string =
  var ic : IntCode = NewIntCode(prog)
  let bad = ["giant electromagnet", "infinite loop",
             "photons", "escape pod", "molten lava"].toHashSet
  var inv : seq[string] = @[]
  var lastDir = ""
  while true:
    var rc = ic.Run()
    if rc == 2 or rc == 1:
      var s = ic.OutputString()
      # echo s
      var i = s.find(" on the keypad", 0)
      if i >= 0:
        return s[i-9..i-1]
      i = s.find("eject")
      if i >= 0:
        if inv.len == 8:
          if debug():
            echo "ready to escape"
          for n in countup(1,8):
            for combo in choose(inv, n):
              for item in inv:
                ic.AddInput("drop " & item & "\n")
              for item in combo:
                ic.AddInput("take " & item & "\n")
              ic.AddInput(lastDir & "\n")
          if debug():
            echo "combinations sent\n"
          continue
        else:
          if debug():
            echo "found exit but we need more items"
      i = s.find("Items here")
      if i >= 0:
        i += 12
        while s[i] == '-':
          var ei = s.find('\n', i)
          if ei >= 0:
            var item = s[i+2..ei-1]
            i = ei+1
            if bad.contains(item):
              if debug():
                echo "ignoring ", item
              continue
            if debug():
              echo "taking ", item
            inv.add item
            ic.AddInput("take " & item & "\n")
          else:
            break
      i = s.find("Doors here lead")
      if i >= 0:
        var dirs : seq[string] = @[]
        for dir in @["north", "south", "east", "west"]:
          if s.find(dir, i) >= 0:
            dirs.add(dir)
        lastDir = dirs.sample()
        ic.AddInput(lastDir & "\n")
  return "error"

var prog = readInputInt64s()
echo "Part 1: ", part1(prog)
