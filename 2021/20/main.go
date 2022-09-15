package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Image struct {
	lookup []bool
	m      []bool
	m2     []bool
	w, h   int
}

func NewImage(in []byte) *Image {
	lookup := make([]bool, 0, 512)
	m := make([]bool, 0, 40000)
	m2 := make([]bool, 0, 40000)
	var i int
	for ; i < len(in) && in[i] != '\n'; i++ {
		v := false
		if in[i] == '#' {
			v = true
		}
		lookup = append(lookup, v)
	}
	i += 2
	y := 0
	x := 0
	w := 0
	for ; i < len(in); i++ {
		switch in[i] {
		case '#':
			m = append(m, true)
		case '.':
			m = append(m, false)
		case '\n':
			w = x
			y++
			x = -1
		}
		x++
	}
	return &Image{lookup, m, m2, w, y}
}

func (i *Image) String() string {
	var sb strings.Builder
	for y := 0; y < i.h; y++ {
		for x := 0; x < i.w; x++ {
			if i.m[x+i.w*y] {
				sb.WriteByte('#')
			} else {
				sb.WriteByte('.')
			}
		}
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (i *Image) value(x, y int, def bool) bool {
	if x < 0 || y < 0 || x >= i.w || y >= i.h {
		return i.lookup[0] && def
	}
	return i.m[x+y*i.w]
}

func (i *Image) index(x, y int, def bool) int {
	n := 0
	if i.value(x+-1, y+-1, def) {
		n = 256
	}
	if i.value(x+0, y+-1, def) {
		n += 128
	}
	if i.value(x+1, y+-1, def) {
		n += 64
	}
	if i.value(x+-1, y+0, def) {
		n += 32
	}
	if i.value(x+0, y+0, def) {
		n += 16
	}
	if i.value(x+1, y+0, def) {
		n += 8
	}
	if i.value(x+-1, y+1, def) {
		n += 4
	}
	if i.value(x+0, y+1, def) {
		n += 2
	}
	if i.value(x+1, y+1, def) {
		n++
	}
	return n
}

func (i *Image) next(x, y int, def bool) bool {
	return i.lookup[i.index(x, y, def)]
}

func (i *Image) Iter(def bool) int {
	m := i.m2[:0]
	c := 0
	for ny, y := 0, -1; y <= i.h; ny, y = ny+1, y+1 {
		for nx, x := 0, -1; x <= i.w; nx, x = nx+1, x+1 {
			if i.next(x, y, def) {
				c++
				m = append(m, true)
			} else {
				m = append(m, false)
			}
		}
	}
	i.w += 2
	i.h += 2
	i.m2, i.m = i.m, m
	return c
}

func (i *Image) Enhance() (int, int) {
	i.Iter(false)
	p1 := i.Iter(true)
	var p2 int
	for n := 3; n <= 50; n += 2 {
		i.Iter(false)
		p2 = i.Iter(true)
	}
	return p1, p2
}

func main() {
	i := NewImage(InputBytes(input))
	p1, p2 := i.Enhance()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
