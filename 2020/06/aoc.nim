import aoclib

var inp = readInputChunks().map(x => x.split("\n").map(y => y.map(ch => ch).toSet))

var unions = inp.map(x => x.foldl(a+b))
echo "Part 1: ", unions.map(len).foldl(a + b)

var intersects = inp.map(x => x.foldl(a * b))
echo "Part 2: ", intersects.map(len).foldl(a + b)
