package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Cup struct {
	val uint
	cw  *Cup
	ccw *Cup
}

func NewCup(v uint) *Cup {
	c := Cup{v, nil, nil}
	c.cw = &c
	c.ccw = &c
	return &c
}

func (c *Cup) InsertAfter(new *Cup) {
	last := new.ccw
	next := c.cw
	c.cw = new
	last.cw = next
	new.ccw = c
	next.ccw = last
}

func (c *Cup) Pick() *Cup {
	p1 := c.cw
	p2 := p1.cw
	p3 := p2.cw
	n := p3.cw

	// fix ring
	c.cw = n
	n.ccw = c

	// make removed a ring
	p1.ccw = p3
	p3.cw = p1
	return p1
}

type CupMap []*Cup

func (c *Cup) String() string {
	s := string(byte(c.val) + '0')
	for n := c.cw; n != c; n = n.cw {
		s += string(byte(n.val) + '0')
	}
	return s
}

func (c *Cup) Part1String() string {
	s := ""
	for cup := c.cw; cup.val != c.val; cup = cup.cw {
		s += string(byte(cup.val) + '0')
	}
	return s
}

type Game struct {
	init  []uint
	debug bool
}

func NewGame(line string) *Game {
	init := make([]uint, len(line))
	for i := range line {
		init[i] = uint(line[i] - '0')
	}
	return &Game{init, true}
}

func (g *Game) Play(moves uint, max uint) *Cup {
	m := make(CupMap, max+1)
	var cur *Cup
	var last *Cup
	for _, v := range g.init {
		n := NewCup(v)
		m[v] = n
		if cur == nil {
			cur = n
		}
		if last != nil {
			last.InsertAfter(n)
		}
		last = n
	}
	for v := uint(10); v <= max; v++ {
		n := NewCup(v)
		m[v] = n
		last.InsertAfter(n)
		last = n
	}
	for move := uint(1); move <= moves; move++ {
		pick := cur.Pick()
		dst := cur.val
		for {
			dst--
			if dst == 0 {
				dst = max
			}
			if dst != pick.val && dst != pick.cw.val && dst != pick.cw.cw.val {
				break
			}
		}
		dcup := m[dst]
		dcup.InsertAfter(pick)
		cur = cur.cw
	}
	return m[1]
}

func (g *Game) Part1(moves uint) string {
	cup1 := g.Play(moves, 9)
	return cup1.Part1String()
}

func (g *Game) Part2(moves uint, max uint) uint {
	cup1 := g.Play(moves, max)
	return cup1.cw.val * cup1.cw.cw.val
}

func main() {
	line := InputLines(input)[0]
	p1 := NewGame(line).Part1(100)
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	p2 := NewGame(line).Part2(10000000, 1000000)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
