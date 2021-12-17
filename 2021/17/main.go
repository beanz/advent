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

func num(in []byte, i int) (int, int) {
	m := 1
	if in[i] == '-' {
		m = -1
		i++
	}
	n := 0
	var j int
	for j = i; j < len(in) && '0' <= in[j] && in[j] <= '9'; j++ {
		n = n*10 + int(in[j] - '0')
	}
	return n*m, j
}

func NewProbe(in []byte) *Probe {
	var i int
	for i = 0; i < len(in) && in[i]!='='; i++ {}
	i++
	xmin, i := num(in, i)
	i+=2
	xmax, i := num(in, i)
	for i = i+1; i < len(in) && in[i]!='='; i++ {}
	i++
	ymin, i := num(in, i)
	i+=2
	ymax, i := num(in, i)

	return &Probe{xmin, xmax, ymin, ymax}
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
