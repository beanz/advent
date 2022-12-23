package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Pos struct {
	x, y int
}

type Elves struct {
	m              map[Pos]struct{}
	xm, xM, ym, yM int
}

func NewElves() *Elves {
	return &Elves{
		m:  map[Pos]struct{}{},
		xm: 999999999,
		xM: -999999999,
		ym: 999999999,
		yM: -999999999,
	}
}

func (e *Elves) String() string {
	var sb strings.Builder
	for y := e.ym; y <= e.yM; y++ {
		for x := e.xm; x <= e.xM; x++ {
			if _, ok := e.m[Pos{x, y}]; ok {
				fmt.Fprintf(&sb, "#")
			} else {
				fmt.Fprintf(&sb, ".")
			}
		}
		fmt.Fprintln(&sb)
	}
	return sb.String()
}

func (e *Elves) Add(x, y int) {
	e.m[Pos{x, y}] = struct{}{}
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

func (e *Elves) NeighBits(x, y int) int {
	b := 0
	if _, ok := e.m[Pos{x - 1, y - 1}]; ok {
		b += 1
	}
	if _, ok := e.m[Pos{x, y - 1}]; ok {
		b += 2
	}
	if _, ok := e.m[Pos{x + 1, y - 1}]; ok {
		b += 4
	}
	if _, ok := e.m[Pos{x - 1, y}]; ok {
		b += 8
	}
	if _, ok := e.m[Pos{x + 1, y}]; ok {
		b += 16
	}
	if _, ok := e.m[Pos{x - 1, y + 1}]; ok {
		b += 32
	}
	if _, ok := e.m[Pos{x, y + 1}]; ok {
		b += 64
	}
	if _, ok := e.m[Pos{x + 1, y + 1}]; ok {
		b += 128
	}
	return b
}

func (e *Elves) Count() int {
	return (1+e.xM-e.xm)*(1+e.yM-e.ym) - len(e.m)
}

type Board struct {
	elves *Elves
	ri    int
}

func (b *Board) String() string {
	return b.elves.String()
}

var (
	checkBits = [4]int{1 + 2 + 4, 32 + 64 + 128, 1 + 8 + 32, 4 + 16 + 128}
	checkOff  = [4]Pos{{0, -1}, {0, 1}, {-1, 0}, {1, 0}}
)

func (b *Board) Iter() int {
	prop := map[Pos]Pos{}
	count := map[Pos]int{}
	for p := range b.elves.m {
		nb := b.elves.NeighBits(p.x, p.y)
		if nb == 0 {
			continue
		}
		for i := 0; i < 4; i++ {
			j := (b.ri + i) % 4
			if nb&checkBits[j] == 0 {
				np := Pos{p.x + checkOff[j].x, p.y + checkOff[j].y}
				prop[p] = np
				count[np]++
				break
			}
		}
	}
	next := NewElves()
	moved := 0
	for p := range b.elves.m {
		np, ok := prop[p]
		if !ok {
			next.Add(p.x, p.y)
			continue
		}
		if count[np] > 1 {
			next.Add(p.x, p.y)
			continue
		}
		next.Add(np.x, np.y)
		moved++
	}
	b.elves = next
	b.ri++
	if b.ri == 4 {
		b.ri = 0
	}
	return moved
}

func Parts(in []byte) (int, int) {
	x, y := 0, 0
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
