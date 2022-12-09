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

func AbsI(x Int) Int {
	if x < 0 {
		return -x
	}
	return x
}

func Move(h, t Pos) Pos {
	dx, dy := h.x-t.x, h.y-t.y
	adx, ady := AbsI(dx), AbsI(dy)
	if adx <= 1 && ady <= 1 {
		return t
	}
	if adx > 1 && ady > 1 {
		if dx > 0 {
			t.x = h.x - 1
		} else {
			t.x = h.x + 1
		}
		if dy > 0 {
			t.y = h.y - 1
		} else {
			t.y = h.y + 1
		}
		return t
	}
	if adx > 1 {
		if dx > 0 {
			t.x = h.x - 1
		} else {
			t.x = h.x + 1
		}
		t.y = h.y
		return t
	}
	if dy > 0 {
		t.y = h.y - 1
	} else {
		t.y = h.y + 1
	}
	t.x = h.x
	return t
}

type Pos struct {
	x, y Int
}

func Parts(in []byte) (int, int) {
	v1, v2 := make(map[Pos]struct{}), make(map[Pos]struct{})
	h := Pos{0, 0}
	t := []Pos{{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}
	for i := 0; i < len(in); i++ {
		ch := in[i]
		j, n := NextUInt(in, i+2)
		i = j
		inc := Pos{0, 0}
		switch ch {
		case 'R':
			inc.x = 1
		case 'L':
			inc.x = -1
		case 'D':
			inc.y = 1
		case 'U':
			inc.y = -1
		}
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
