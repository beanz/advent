import aoclib
from bitops import reverseBits

proc reverse10Bits(n : uint16) : uint16 =
  return reverseBits(n shl 6)

proc canonicalEdge(e : uint16) : uint16 =
  var re = reverse10Bits(e)
  return if re < e: re else: e

type Tile = ref object
  num : int
  lines : seq[string]
  width : int
  top : uint16
  right : uint16
  bottom : uint16
  left : uint16

method updateEdges(s: var Tile) : void {.base.} =
  s.top = 0
  s.right = 0
  s.bottom = 0
  s.left = 0
  var ei = s.width-1
  for i in countup(0, ei):
    s.top = s.top shl 1
    s.right = s.right shl 1
    s.bottom = s.bottom shl 1
    s.left = s.left shl 1
    if s.lines[0][i] == '#':
      s.top += 1
    if s.lines[i][ei] == '#':
      s.right += 1
    if s.lines[ei][i] == '#':
      s.bottom += 1
    if s.lines[i][0] == '#':
      s.left += 1

proc initTile(ts: string) : Tile =
  var ss = ts.split("\n")
  var num = parseInt(ss[0][5..8])
  var l : seq[string] = @[]
  for i in countup(1, ss.len-1):
    l.add(ss[i])
  var t = Tile(num: num, lines: l, width: l[0].len,
               top: 0, right: 0, bottom: 0, left: 0)
  t.updateEdges()
  return t

method pretty(s: Tile) : string {.base.} =
  return "Tile " & $(s.num) & ":\n" & s.lines.join("\n") & "\n"

method flip(s: var Tile) : void {.base.} =
  var r = deepCopy(s.lines)
  for i, l in s.lines:
    r[r.len-1-i] = l
  s.lines = r
  s.updateEdges()

method rotate(s: var Tile) : void {.base.} =
  s.lines = rotateStrings(s.lines)
  s.updateEdges()

type Game = object
  tiles : Table[int, Tile]
  edges : Table[uint16, seq[int]]
  starter: int
  width: int

proc initGame(inp : seq[string]) : Game =
  var edges = initTable[uint16, seq[int]]()
  var tiles = initTable[int, Tile]()
  for ts in inp:
    var tile = initTile(ts)
    tiles[tile.num] = tile
    for e in @[tile.top, tile.right, tile.bottom, tile.left]:
      var ce = canonicalEdge(e)
      if not edges.contains(ce):
        edges[ce] = @[]
      edges[ce].add(tile.num)
  return Game(tiles: tiles, edges: edges, starter: 0, width: isqrt(tiles.len))

method edgeTiles(s : Game, e : uint16) : seq[int] {.base.} =
  var ce = canonicalEdge(e)
  return s.edges[ce]

method edgeTileCount(s : Game, e : uint16) : int {.base.} =
  return s.edgeTiles(e).len

method part1(s: var Game) : int {.base.} =
  var p = 1
  for tile in s.tiles.values:
    var c = 0
    for e in @[tile.top, tile.right, tile.bottom, tile.left]:
      if s.edgeTileCount(e) > 1:
        c += 1
    if c == 2:
      if debug():
        echo "found corner ", tile.num
      p *= tile.num
      s.starter = tile.num
  return p

method findRightTile(s: var Game, n : int) : int {.base.} =
  var tile = s.tiles[n]
  var e = tile.right
  var matching = s.edgeTiles(e).filter(nn => nn != n)[0]
  var new = s.tiles[matching]
  for i in countup(0, 7):
    if new.left == e:
      return new.num
    if i == 3:
      new.flip()
    else:
      new.rotate()
  raise newException(ValueError, "failed to find matching tile")

method findBottomTile(s: var Game, n : int) : int {.base.} =
  var tile = s.tiles[n]
  var e = tile.bottom
  var matching = s.edgeTiles(e).filter(nn => nn != n)[0]
  var new = s.tiles[matching]
  for i in countup(0, 7):
    if new.top == e:
      return new.num
    if i == 3:
      new.flip()
    else:
      new.rotate()
  raise newException(ValueError, "failed to find matching tile")

method image(s: var Game) : seq[string] {.base.} =
  if s.starter == 0:
    discard s.part1()
  if debug():
    echo "starting with corner ", s.starter
  var t = s.tiles[s.starter]
  var layout : seq[int] = @[]
  while s.edgeTileCount(t.right) != 2 or s.edgeTileCount(t.bottom) != 2:
    t.rotate # rotate until matching edges are right and bottom edges
  layout.add(t.num)
  for i in countup(1, s.width*s.width-1):
    var tn = 0
    if (i mod s.width) == 0:
      tn = s.findBottomTile(layout[i-s.width])
    else:
      tn = s.findRightTile(layout[i-1])
    if debug():
      echo "found ", i, ": ", tn
    layout.add(tn)
  var res : seq[string] = @[]
  for irow in countup(0, s.width-1):
    for trow in countup(1, t.width-2):
      var row = ""
      for icol in countup(0, s.width-1):
        var tt = s.tiles[layout[irow*s.width + icol]]
        row &= tt.lines[trow][1..^2]
      res.add(row)
  return res

method part2(s: var Game) : int {.base.} =
  var im = s.image()
  let ih = im.len
  let iw = im[0].len
  let water = im.map(l => l.count('#')).foldl(a+b)
  let monster = aoclib.readLines("monster.txt")
  let monsterSize = monster.map(l => l.count('#')).foldl(a+b)
  let mh = monster.len
  let mw = monster[0].len
  if debug():
    echo im.join("\n")
    echo monster.join("\n")
    echo "image ", iw, " x ", ih, " ", water
    echo "mnstr ", mw, " x ", mh, " ", monsterSize
  var mchars = 0
  for i in countup(0, 7):
    for r in countup(0, (ih-mh)-1):
      for c in countup(0, (iw-mw)-1):
        var match = true
        for mr in countup(0, mh-1):
          for mc in countup(0, mw-1):
            if monster[mr][mc] != '#':
              continue
            if im[r+mr][c+mc] != '#':
              match = false
              break
          if not match:
            break
        if match:
          if debug():
            echo "found monster at ", c, ",", r
          mchars += monsterSize
    if i == 3:
      var old = deepCopy(im)
      for i, l in old:
        im[old.len-1-i] = l
    else:
      im = rotateStrings(im)
  return water - mchars

var inp = readInputChunks()
var g = initGame(inp)
echo "Part 1: ", g.part1()
echo "Part 2: ", g.part2()
