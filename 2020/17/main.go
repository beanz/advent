package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Cube []int

func (c Cube) Key() int {
	k := 0
	for _, x := range c {
		k <<= 5
		k += (x + 15)
	}
	k <<= 5
	k += len(c)
	return k
}

func (c Cube) SymKey() int {
	k := 0
	for i, x := range c {
		k <<= 5
		if i > 1 && x < 0 {
			k += (-x + 15)
		} else {
			k += (x + 15)
		}
	}
	k <<= 5
	k += len(c)
	return k
}

func KeyToCube(k int) Cube {
	dim := k & 0x1f
	k >>= 5
	c := make(Cube, dim)
	for i := dim - 1; i >= 0; i-- {
		c[i] = (k & 0x1f) - 15
		k >>= 5
	}
	return c
}

func (a Cube) Add(b Cube) Cube {
	r := make(Cube, len(a))
	for i := 0; i < len(a); i++ {
		r[i] = a[i] + b[i]
	}
	return r
}

func PrependInt(e int, l []int) []int {
	n := make([]int, len(l)+1)
	if len(l) > 0 {
		copy(n[1:], l)
	}
	n[0] = e
	return n
}

func (c Cube) Neighbours() []Cube {
	var aux func(c Cube, i int) []Cube
	aux = func(c Cube, i int) []Cube {
		if i == len(c) {
			return []Cube{Cube{}}
		}
		res := []Cube{}
		for _, sc := range aux(c, i+1) {
			res = append(res, PrependInt(c[i]-1, sc))
			res = append(res, PrependInt(c[i], sc))
			res = append(res, PrependInt(c[i]+1, sc))
		}
		return res
	}
	res := []Cube{}
	for _, sc := range aux(c, 0) {
		zeroCount := 0
		for _, n := range sc {
			if n == 0 {
				zeroCount++
			}
		}
		if zeroCount != len(c) {
			res = append(res, sc)
		}
	}
	return res
}

type Cubes map[int]bool

type Map struct {
	cur   Cubes
	new   Cubes
	nb    []Cube
	debug bool
}

func NewMap(lines []string, dim int) *Map {
	cur := make(Cubes)
	new := make(Cubes)
	zero := make(Cube, dim)
	m := &Map{cur, new, zero.Neighbours(), DEBUG()}
	for y, line := range lines {
		for x, s := range line {
			c := Cube{x, y}
			for i := 0; i < dim-2; i++ {
				c = append(c, 0)
			}
			if s == '#' {
				m.Set(c, true)
			}
		}
	}
	m.Swap()
	return m
}

func (m *Map) String() string {
	s := ""
	for z := -1; z <= 1; z++ {
		s += fmt.Sprintf("z=%d\n", z)
		for y := -1; y <= 5; y++ {
			for x := -1; x <= 5; x++ {
				if m.Get(Cube{x, y, z}) {
					s += "#"
				} else {
					s += "."
				}
			}
			s += fmt.Sprintf(" (%d)\n", y)
		}
	}
	return s
}

func (m *Map) AllNeighbours() []Cube {
	seen := make(map[int]bool, len(m.cur)*5)
	res := []Cube{}
	for cs := range m.cur {
		c := KeyToCube(cs)
		if !seen[cs] {
			seen[cs] = true
			res = append(res, c)
		}
		for _, no := range m.nb {
			nc := c.Add(no)
			if !seen[nc.Key()] {
				res = append(res, nc)
			}
			seen[nc.Key()] = true
		}
	}
	return res
}

func (m *Map) Set(c Cube, state bool) {
	m.new[c.Key()] = state
}

func (m *Map) Swap() {
	m.cur, m.new = m.new, m.cur
}

func (m *Map) Get(c Cube) bool {
	return m.cur[c.Key()]
}

func (m *Map) NeighbourCount(c Cube) int {
	n := 0
	for _, no := range m.nb {
		nc := c.Add(no)
		if m.Get(nc) {
			n++
		}
	}
	return n
}

func (m *Map) Iter() int {
	n := 0
	a := 0
	sym := make(map[int]int, len(m.cur)/2)
	for _, c := range m.AllNeighbours() {
		a++
		sk := c.SymKey()
		var nc int
		var ok bool
		nc, ok = sym[sk]
		if !ok {
			nc = m.NeighbourCount(c)
			sym[sk] = nc
		}
		cur := m.Get(c)
		var new bool
		if (cur && nc == 2) || nc == 3 {
			new = true
		}
		//if DEBUG() {
		//	fmt.Printf("%v (%d) %v %v\n", c, nc, cur, new)
		//}
		m.Set(c, new)
		if new {
			n++
		}
	}
	m.Swap()
	if DEBUG() {
		fmt.Printf("Live %d (%d)\n", n, a)
		//fmt.Printf("%s\n", m)
	}
	return n
}

func (m *Map) Calc() int {
	r := 0
	if DEBUG() {
		fmt.Printf("%s\n", m)
	}
	for i := 0; i < 6; i++ {
		r = m.Iter()
	}
	return r
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewMap(lines, 3).Calc())
	fmt.Printf("Part 2: %d\n", NewMap(lines, 4).Calc())
}
