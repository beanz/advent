package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int int32

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

func Move(h, t Pos) Pos {
	dx, dy := h.x-t.x, h.y-t.y
	if dx <= 1 && dx >= -1 && dy <= 1 && dy >= -1 {
		return t
	}
	if dx > 1 {
		t.x = h.x - 1
	} else if dx < -1 {
		t.x = h.x + 1
	} else {
		t.x = h.x
	}
	if dy > 1 {
		t.y = h.y - 1
	} else if dy < -1 {
		t.y = h.y + 1
	} else {
		t.y = h.y
	}
	return t
}

type Pos struct {
	x, y Int
}

var Inc = [86]Pos{'R': {1, 0}, 'L': {-1, 0}, 'D': {0, 1}, 'U': {0, -1}}

func Parts(in []byte) (int, int) {
	v1, v2 := make(map[Pos]struct{}, 6000), make(map[Pos]struct{}, 3000)
	h := Pos{0, 0}
	t := []Pos{{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}
	for i := 0; i < len(in); i++ {
		ch := in[i]
		j, n := NextUInt(in, i+2)
		i = j
		inc := Inc[ch]
		for j := 0; j < int(n); j++ {
			h.x, h.y = h.x+inc.x, h.y+inc.y
			t[0] = Move(h, t[0])
			for k := 1; k <= 8; k++ {
				t[k] = Move(t[k-1], t[k])
			}
			v1[t[0]] = struct{}{}
			v2[t[8]] = struct{}{}
		}
	}
	return len(v1), len(v2)
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
