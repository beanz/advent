package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Life struct {
	init []bool
	cur  []bool
	next []bool
	size int
}

func NewLife(in []string) *Life {
	size := len(in)
	life := &Life{
		init: make([]bool, size*size),
		cur:  make([]bool, size*size),
		next: make([]bool, size*size),
		size: size,
	}
	for y, l := range in {
		for x, ch := range l {
			if ch == '#' {
				life.Set(x, y, true)
			}
		}
	}
	life.next, life.init = life.init, life.next
	return life
}

func (l *Life) String() string {
	s := ""
	for y := 0; y < l.size; y++ {
		for x := 0; x < l.size; x++ {
			if l.Get(x, y) {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func (l *Life) Get(x, y int) bool {
	if x < 0 || x >= l.size || y < 0 || y >= l.size {
		return false
	}
	return l.cur[x+y*l.size]
}

func (l *Life) Set(x, y int, val bool) {
	if x < 0 || x >= l.size || y < 0 || y >= l.size {
		panic("Set out of range")
	}
	l.next[x+y*l.size] = val
}

func (l *Life) NeighbourCount(x, y int) int {
	c := 0
	for _, io := range [][2]int{
		{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1},
	} {
		if l.Get(x+io[0], y+io[1]) {
			c++
		}
	}
	return c
}

func (l *Life) Part1(rounds int) int {
	copy(l.cur, l.init)
	var c int
	for r := 0; r < rounds; r++ {
		c = 0
		for y := 0; y < l.size; y++ {
			for x := 0; x < l.size; x++ {
				nc := l.NeighbourCount(x, y)
				new := (l.Get(x, y) && nc == 2) || nc == 3
				l.Set(x, y, new)
				if new {
					c++
				}
			}
		}
		l.cur, l.next = l.next, l.cur
	}
	return c
}

func (l *Life) Part2(rounds int) int {
	copy(l.cur, l.init)
	copy(l.cur, l.init)
	l.cur[0+0*l.size] = true
	l.cur[l.size-1+0*l.size] = true
	l.cur[0+(l.size-1)*l.size] = true
	l.cur[l.size-1+(l.size-1)*l.size] = true
	if rounds == 4 {
		rounds = 5
	}
	var c int
	for r := 0; r < rounds; r++ {
		c = 0
		for y := 0; y < l.size; y++ {
			for x := 0; x < l.size; x++ {
				var new bool
				if (x == 0 || x == l.size-1) && (y == 0 || y == l.size-1) {
					new = true
				} else {
					nc := l.NeighbourCount(x, y)
					new = (l.Get(x, y) && nc == 2) || nc == 3
				}
				l.Set(x, y, new)
				if new {
					c++
				}
			}
		}
		l.cur, l.next = l.next, l.cur
	}
	return c
}

func main() {
	file := InputFile()
	s := InputLines(input)
	rounds := 100
	if file != "input.txt" {
		rounds = 4
	}
	l := NewLife(s)
	p1 := l.Part1(rounds)
	p2 := l.Part2(rounds)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
