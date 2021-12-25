package main

import (
	_ "embed"
	"fmt"
	"strings"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type SC []bool

type Cucumbers struct {
	e SC
	s SC
	w, h int
}

func NewCucumbers(in []byte) *Cucumbers {
	c := &Cucumbers{make(SC, len(in)),make(SC, len(in)), 0, 0}
	x := 0
	y := 0
	w := 0
	for _, ch := range in {
		switch ch {
		case '>':
			c.e[x+y*w] = true
		case 'v':
			c.s[x+y*w] = true
		case '\n':
			w = x
			x = -1
			y++
		}
		x++
	}
	c.w = w
	c.h = y
	return c
}

func (c *Cucumbers) String() string {
	var sb strings.Builder
	for y := 0; y < c.h; y++ {
		for x := 0; x < c.w; x++ {
			if c.e[x+y*c.w] {
				sb.WriteByte('>')
			} else if c.s[x+y*c.w] {
				sb.WriteByte('v')
			} else {
				sb.WriteByte('.')
			}
		}
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (c *Cucumbers) Iter() int {
	m := []int{}
	for i := 0; i < len(c.e); i++ {
		if !c.e[i] {
			continue
		}
		mi := (i%c.w+1)%c.w + c.w*(i/c.w)
		if !c.e[mi] && !c.s[mi] {
			m = append(m, i)
		}
	}
	for _, i := range m {
		c.e[i] = false
		mi := (i%c.w+1)%c.w + c.w*(i/c.w)
		c.e[mi] = true
	}
	mc := len(m)
	m = m[:0]
	for i := 0; i < len(c.s); i++ {
		if !c.s[i] {
			continue
		}
		mi := (i%c.w) + c.w*((i/c.w+1)%c.h)
		if !c.e[mi] && !c.s[mi] {
			m = append(m, i)
		}
	}
	mc += len(m)
	for _, i := range m {
		c.s[i] = false
		mi := (i%c.w) + c.w*((i/c.w+1)%c.h)
		c.s[mi] = true
	}
	return mc
}

func (c *Cucumbers) Part1() int {
	d := 1
	for c.Iter() > 0 {
		d++
	}
	return d
}

func main() {
	c := NewCucumbers(InputBytes(input))
	p1 := c.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
}

var benchmark = false
