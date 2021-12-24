package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type CellCache struct {
	m    []int
	size int
}

func NewCellCache(size int, serial int) *CellCache {
	m := make([]int, size*size)
	cc := &CellCache{m, size}
	for y := 0; y < size; y++ {
		for x := 0; x < size; x++ {
			l := cc.Level(x+1, y+1, serial)
			if x > 0 {
				l += m[(x-1)+size*y]
				if y > 0 {
					l -= m[(x-1)+size*(y-1)]
				}
			}
			if y > 0 {
				l += m[x+size*(y-1)]
			}
			m[x+size*y] = l
		}
	}
	return cc
}

func (cc *CellCache) Level(x, y, serial int) int {
	r := x + 10
	p := r * y
	p += serial
	p *= r
	p /= 100
	p %= 10
	return p - 5
}

func (cc *CellCache) Get(x, y int) int {
	return cc.m[x+y*cc.size]
}

type Cells struct {
	serial     int
	sizeMin    int
	sizeMax    int
	xmin, xmax int
	ymin, ymax int
	cc         *CellCache
	debug      bool
}

func NewCells(in []byte) *Cells {
	ints := FastInts(in, 7)
	return &Cells{ints[0], ints[1], ints[2],
		ints[3], ints[5], ints[4], ints[6], NewCellCache(ints[2], ints[0]),
		false,
	}
}

func (c *Cells) LevelSquare(x, y, size int) int {
	s := c.cc.Get(x+size-1, y+size-1)
	if x > 0 {
		s -= c.cc.Get(x-1, y+size-1)
		if y > 0 {
			s += c.cc.Get(x-1, y-1)
		}
	}
	if y > 1 {
		s -= c.cc.Get(x+size-1, y-1)
	}
	return s
}

func (c *Cells) Solve(minSize, maxSize int) (int, int, int) {
	var maxX, maxY, mSize int
	max := math.MinInt64
	for size := minSize; size <= maxSize; size++ {
		for x := c.xmin - 1; x < c.xmax-size+1; x++ {
			if c.debug {
			fmt.Printf("%3d %3d\r", size, x)
			}
			for y := c.ymin - 1; y < c.ymax-size+1; y++ {
				l := c.LevelSquare(x, y, size)
				if l > max {
					max, maxX, maxY, mSize = l, x, y, size
				}
			}
		}
	}
	return maxX+1, maxY+1, mSize
}

func (c *Cells) Part1() string {
	x, y, _ := c.Solve(3, 3)
	return fmt.Sprintf("%d,%d", x, y)
}

func (c *Cells) Part2() string {
	x, y, size := c.Solve(1, 300)
	return fmt.Sprintf("%d,%d,%d", x, y, size)
}

func main() {
	c := NewCells(InputBytes(input))
	p1 := c.Part1()
	p2 := c.Part2()
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
