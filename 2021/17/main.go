package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Probe struct {
	xmin, xmax, ymin, ymax int
}

func NewProbe(in []byte) *Probe {
	ints := FastSignedInts(in, 4)
	return &Probe{ints[0], ints[1], ints[2], ints[3]}
}

func (p *Probe) Part1() int {
	return p.ymin*(p.ymin+1)/2
}

func (p *Probe) Try(vx, vy int) bool {
	x, y := 0, 0
	for {
		x += vx
		y += vy
		if vx > 0 {
			vx--
		}
		vy--
		if y < p.ymin {
			return false
		}
		if p.xmin <= x && x <= p.xmax {
			if y <= p.ymax {
				return true
			}
		} else if vx == 0 {
			return false
		}
	}
}

func (p *Probe) Part2() int {
	p2 := 0
	ry := Abs(p.ymin)
	vx := 0 // min vx is vx+(vx-1)+..+1 > p.xmin
	for x := 0; x < p.xmin; x += vx {
		vx++
	}
	for ; vx <= p.xmax; vx++ {
		for vy := -ry; vy <= ry; vy++ {
			if p.Try(vx, vy) {
				p2++
			}
		}
	}
	return p2
}

func main() {
	p := NewProbe(InputBytes(input))
	p1 := p.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := p.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
