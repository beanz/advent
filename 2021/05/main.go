package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const (
	X1 = 0
	Y1 = 1
	X2 = 2
	Y2 = 3
)

type Line []int

func (l Line) Norm() (int, int) {
	nx, ny := 0, 0
	if l[X1] > l[X2] {
		nx = -1
	} else if l[X1] < l[X2] {
		nx = 1
	}
	if l[Y1] > l[Y2] {
		ny = -1
	} else if l[Y1] < l[Y2] {
		ny = 1
	}
	return nx, ny
}

type Diag struct {
	ints  []int
	debug bool
}

func NewDiag(in []byte) *Diag {
	ints := FastInts(in, 2048)
	return &Diag{ints, false}
}

func (d *Diag) Overlaps() (int, int) {
	d1 := make([]byte, 1024*1024)
	c1 := 0
	c2 := 0
	for i := 0; i < len(d.ints); i += 4 {
		line := Line(d.ints[i : i+4])
		nx, ny := line.Norm()
		p1inc := nx == 0 || ny == 0
		var lineLen = MaxInt(Abs(line[X1]-line[X2]), Abs(line[Y1]-line[Y2]))
		for i, x, y := 0, line[X1], line[Y1]; i <= lineLen; i, x, y = i+1, x+nx, y+ny {
			k := y<<10 + x
			v := d1[k]
			p1, p2 := v%8, v/8
			if p1 > 2 && p2 > 2 {
				continue
			}
			if p1inc {
				p1++
				if p1 == 2 {
					c1++
				}
			}
			p2++
			if p2 == 2 {
				c2++
			}
			d1[k] = p1 + p2<<3
		}
	}
	return c1, c2
}

func main() {
	d := NewDiag(InputBytes(input))
	p1, p2 := d.Overlaps()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
