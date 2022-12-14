package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int = int32
type Occupied [147456]bool

func (o *Occupied) Add(x, y Int) {
	o[x*192+y] = true
}

func (o *Occupied) Empty(x, y Int) bool {
	return !o[x*192+y]
}

func Debug(m *Occupied, bb *FBoundingBox) {
	minx, maxx, _, maxy := bb.Limits()
	for y := Int(0); y <= maxy; y++ {
		for x := minx; x <= maxx; x++ {
			if !m.Empty(x, y) {
				fmt.Print(string('#'))
			} else {
				fmt.Print(".")
			}
		}
		fmt.Println()
	}
}

func Parts(in []byte) (int, int) {
	bb := NewFBoundingBox()
	m := Occupied{}
	for i := 0; i < len(in); i++ {
		j, x := NextUInt(in, i)
		i = j + 1
		j, y := NextUInt(in, i)
		i = j
		p := NewFP2(x, y)
		m.Add(x, y)
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
				px, py := p.XY()
				m.Add(px, py)
			}
		}
	}
	//Debug(&m, bb)
	p1 := 0
	c := 0
	minx, maxx, _, maxy := bb.Limits()
	var sx int32 = 500
	var sy int32
	for {
		if p1 == 0 && (sx > maxx || sx < minx) {
			p1 = c
		}
		if sy < maxy+1 {
			if m.Empty(sx, sy+1) {
				sy++
				continue
			}
			if m.Empty(sx-1, sy+1) {
				sx--
				sy++
				continue
			}
			if m.Empty(sx+1, sy+1) {
				sx++
				sy++
				continue
			}
		}
		m.Add(sx, sy)
		c++
		if sx == 500 && sy == 0 {
			break
		}
		sx = 500
		sy = 0
	}
	return p1, c
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
