package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	bb := NewFBoundingBox()
	m := make(map[FP2]byte, 25600)
	for i := 0; i < len(in); i++ {
		j, x := NextUInt(in, i)
		i = j + 1
		j, y := NextUInt(in, i)
		i = j
		p := NewFP2(x, y)
		m[p] = '#'
		bb.Add(p)
		for i < len(in) && in[i] != '\n' {
			i += 4
			j, nx := NextUInt(in, i)
			i = j + 1
			j, ny := NextUInt(in, i)
			i = j
			p2 := NewFP2(nx, ny)
			n2 := p.Norm(p2)
			for p != p2 {
				p = p.Add(n2)
				bb.Add(p)
				m[p] = '#'
			}
		}
	}
	p1 := solve(m, bb, 0)
	p2 := solve(m, bb, p1)
	return p1, p2
}

func solve(m map[FP2]byte, bb *FBoundingBox, start int) int {
	minx, maxx, _, maxy := bb.Limits()
	c := start
	var sx int32 = 500
	var sy int32
	for {
		if start == 0 && (sx > maxx || sx < minx) {
			break
		}
		if sy < maxy+1 {
			if _, ok := m[NewFP2(sx, sy+1)]; !ok {
				sy++
				continue
			}
			if _, ok := m[NewFP2(sx-1, sy+1)]; !ok {
				sx--
				sy++
				continue
			}
			if _, ok := m[NewFP2(sx+1, sy+1)]; !ok {
				sx++
				sy++
				continue
			}
		}
		if sx == 500 && sy == 0 {
			c++
			break
		}
		m[NewFP2(sx, sy)] = 'o'
		c++
		sx = 500
		sy = 0
	}
	return c
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

func NextUInt(in []byte, i int) (j int, n int32) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int32(in[j]-'0')
	}
	return
}

var benchmark = false
