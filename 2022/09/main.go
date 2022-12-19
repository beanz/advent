package main

import (
	_ "embed"
	"fmt"
	"math/bits"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int int

func Move(h, t Pos) (Pos, bool) {
	dx, dy := h.x-t.x, h.y-t.y
	if dx <= 1 && dx >= -1 && dy <= 1 && dy >= -1 {
		return t, false
	}
	if dx > 0 {
		t.x++
	} else if dx < 0 {
		t.x--
	}
	if dy > 0 {
		t.y++
	} else if dy < 0 {
		t.y--
	}
	return t, true
}

type Pos struct {
	x, y Int
}

var Inc = [86]Pos{'R': {1, 0}, 'L': {-1, 0}, 'D': {0, 1}, 'U': {0, -1}}

func Parts(in []byte) (int, int) {
	v1, v2 := VisitMap{}, VisitMap{}
	t := [10]Pos{}
	for i := 0; i < len(in); i++ {
		ch := in[i]
		j, n := ChompUInt[int](in, i+2)
		i = j
		inc := Inc[ch]
		var dragged bool
		for j := 0; j < int(n); j++ {
			t[0].x, t[0].y = t[0].x+inc.x, t[0].y+inc.y
			for k := 1; k <= 9; k++ {
				t[k], dragged = Move(t[k-1], t[k])
				if !dragged {
					break
				}
			}
			v1.Visit(t[1])
			v2.Visit(t[9])
		}
	}
	return v1.Len(), v2.Len()
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

const mapRange = 512
const mapRange2 = mapRange * 2
const mapSize = mapRange2 * mapRange2 / 64

type VisitMap [mapSize]uint64

func (v *VisitMap) Visit(p Pos) {
	i := (p.x + mapRange) + (p.y+mapRange)*mapRange2
	b := i >> 6
	var bit uint64 = 1 << (i & 0x3f)
	v[b] |= bit
}

func (v *VisitMap) Len() int {
	c := 0
	for _, b := range v {
		c += bits.OnesCount64(b)
	}
	return c
}

var benchmark = false
