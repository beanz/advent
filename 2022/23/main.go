package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int int32

type Pos struct {
	x, y Int
}

func (p Pos) Index() Int {
	return (128+p.x)<<8 + (128 + p.y)
}

type Elves struct {
	m              [65536]bool
	c              int
	xm, xM, ym, yM Int
}

func NewElves() *Elves {
	return &Elves{
		m:  [65536]bool{},
		c:  0,
		xm: 999999999,
		xM: -999999999,
		ym: 999999999,
		yM: -999999999,
	}
}

func (e *Elves) Index(x, y Int) Int {
	return (128+x)<<8 + (128 + y)
}

func (e *Elves) Contains(x, y Int) bool {
	return e.m[e.Index(x, y)]
}

func (e *Elves) Visit(fn func(x, y Int)) {
	for y := e.ym; y <= e.yM; y++ {
		for x := e.xm; x <= e.xM; x++ {
			i := e.Index(Int(x), Int(y))
			if e.m[i] {
				fn(Int(x), Int(y))
			}
		}
	}
}

func (e *Elves) String() string {
	var sb strings.Builder
	for y := e.ym; y <= e.yM; y++ {
		for x := e.xm; x <= e.xM; x++ {
			if e.Contains(Int(x), Int(y)) {
				fmt.Fprintf(&sb, "#")
			} else {
				fmt.Fprintf(&sb, ".")
			}
		}
		fmt.Fprintln(&sb)
	}
	return sb.String()
}

func (e *Elves) Add(x, y Int) {
	e.c++
	e.m[e.Index(x, y)] = true
	if e.xm > x {
		e.xm = x
	}
	if e.xM < x {
		e.xM = x
	}
	if e.ym > y {
		e.ym = y
	}
	if e.yM < y {
		e.yM = y
	}
}

func (e *Elves) NeighBits(x, y Int) Int {
	var b Int
	if e.Contains(x-1, y-1) {
		b += 1
	}
	if e.Contains(x, y-1) {
		b += 2
	}
	if e.Contains(x+1, y-1) {
		b += 4
	}
	if e.Contains(x-1, y) {
		b += 8
	}
	if e.Contains(x+1, y) {
		b += 16
	}
	if e.Contains(x-1, y+1) {
		b += 32
	}
	if e.Contains(x, y+1) {
		b += 64
	}
	if e.Contains(x+1, y+1) {
		b += 128
	}
	return b
}

func (e *Elves) Count() int {
	return int(1+e.xM-e.xm)*int(1+e.yM-e.ym) - e.c
}

type Board struct {
	elves *Elves
	ri    int
}

func (b *Board) String() string {
	return b.elves.String()
}

var (
	checkBits = [4]Int{1 + 2 + 4, 32 + 64 + 128, 1 + 8 + 32, 4 + 16 + 128}
	checkOff  = [4]Pos{{0, -1}, {0, 1}, {-1, 0}, {1, 0}}
)

func (b *Board) Iter() int {
	prop := [65536]*Pos{}
	count := [65536]Int{}
	b.elves.Visit(func(x, y Int) {
		p := Pos{x, y}
		nb := b.elves.NeighBits(p.x, p.y)
		if nb == 0 {
			return
		}
		for i := 0; i < 4; i++ {
			j := (b.ri + i) % 4
			if nb&checkBits[j] == 0 {
				np := Pos{p.x + checkOff[j].x, p.y + checkOff[j].y}
				prop[p.Index()] = &np
				count[np.Index()]++
				break
			}
		}
	})
	next := NewElves()
	moved := 0
	b.elves.Visit(func(x, y Int) {
		p := Pos{x, y}
		np := prop[p.Index()]
		if np == nil {
			next.Add(p.x, p.y)
			return
		}
		if count[np.Index()] > 1 {
			next.Add(p.x, p.y)
			return
		}
		next.Add(np.x, np.y)
		moved++
	})
	b.elves = next
	b.ri++
	if b.ri == 4 {
		b.ri = 0
	}
	return moved
}

func Parts(in []byte) (int, int) {
	var x, y Int
	elves := NewElves()
	b := Board{elves: elves}
	for _, ch := range in {
		switch ch {
		case '#':
			elves.Add(x, y)
			x++
		case '\n':
			y++
			x = 0
		default:
			x++
		}
	}
	p1 := -1
	var r = 1
	//fmt.Printf("%s\n", b.String())
	for ; r < 10000; r++ {
		moved := b.Iter()
		if r == 10 {
			p1 = b.elves.Count()
		}
		if moved == 0 {
			break
		}
		//fmt.Printf("Round %d m=%d c=%d %s\n", r, moved, b.elves.Count(), b.String())
	}
	return p1, r
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
