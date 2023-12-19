package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	mul := 1000000
	if len(args) != 0 {
		mul = args[0]
	}
	bm := NewByteMap(in)
	cx := [140]int{}
	cy := [140]int{}
	gc := 0
	xmin, xmax, ymin, ymax := bm.Width(), 0, bm.Height(), 0
	for y := 0; y < bm.Height(); y++ {
		for x := 0; x < bm.Width(); x++ {
			if bm.GetXY(x, y) != '.' {
				gc++
				cx[x]++
				cy[y]++
				if x > xmax {
					xmax = x
				}
				if x < xmin {
					xmin = x
				}
			}
		}
		if cy[y] > 0 {
			if y > ymax {
				ymax = y
			}
			if y < ymin {
				ymin = y
			}
		}
	}
	dx1, dx2 := dist(gc, xmin, xmax, cx, mul)
	dy1, dy2 := dist(gc, ymin, ymax, cy, mul)
	return dx1 + dy1, dx2 + dy2
}

func dist(gc, min, max int, v [140]int, mul int) (int, int) {
	exp1, exp2 := 0, 0
	d1, d2 := 0, 0
	px := min
	nx := v[min]
	for x := min + 1; x <= max; x += 1 {
		if v[x] > 0 {
			d1 += (x - px + exp1) * nx * (gc - nx)
			d2 += (x - px + exp2) * nx * (gc - nx)
			nx += v[x]
			px = x
			exp1, exp2 = 0, 0
		} else {
			exp1 += 1
			exp2 += mul - 1
		}
	}
	return d1, d2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
