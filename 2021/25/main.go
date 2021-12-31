package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type SC []bool

type Cucumbers struct {
	m    *ByteMap
	w, h int
}

func NewCucumbers(in []byte) *Cucumbers {
	m := NewByteMap(in)
	return &Cucumbers{m, m.Width(), m.Height()}
}

func (c *Cucumbers) String() string {
	return c.m.String()
}

func (c *Cucumbers) Iter() int {
	moved := 0
	for y := 0; y < c.h; y++ {
		i := c.m.XYToIndex(0, y)
		max := i + c.w - 1
		if c.m.Get(i) == '.' && c.m.Get(max) == '>' {
			moved++
			c.m.Set(i, '>')
			c.m.Set(max, '.')
			i++
			max--
		}
		for ; i < max; i++ {
			if c.m.Get(i) == '>' && c.m.Get(i+1) == '.' {
				moved++
				c.m.Set(i, '.')
				c.m.Set(i+1, '>')
				i++
			}
		}
	}
	for x := 0; x < c.w; x++ {
		y := 0
		max := c.h - 1
		if c.m.GetXY(x, y) == '.' && c.m.GetXY(x, max) == 'v' {
			moved++
			c.m.SetXY(x, y, 'v')
			c.m.SetXY(x, max, '.')
			y++
			max--
		}
		for ; y < max; y++ {
			if c.m.GetXY(x, y) == 'v' && c.m.GetXY(x, y+1) == '.' {
				moved++
				c.m.SetXY(x, y, '.')
				c.m.SetXY(x, y+1, 'v')
				y++
			}
		}
	}
	return moved
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
