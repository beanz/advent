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
	cx := [140]bool{}
	cy := [140]bool{}
	for y := 0; y < bm.Height(); y++ {
		for x := 0; x < bm.Width(); x++ {
			if bm.GetXY(x, y) != '.' {
				cy[y] = true
				break
			}
		}
	}
	for x := 0; x < bm.Width(); x++ {
		for y := 0; y < bm.Height(); y++ {
			if bm.GetXY(x, y) != '.' {
				cx[x] = true
				break
			}
		}
	}
	return solve(bm, cx, cy, 2), solve(bm, cx, cy, mul)
}

func solve(bm *ByteMap, cx, cy [140]bool, mul int) int {
	ax, ay := 0, 0
	g := make([][2]int, 0, 512)
	for y := 0; y < bm.Height(); y++ {
		for x := 0; x < bm.Width(); x++ {
			if bm.GetXY(x, y) != '.' {
				g = append(g, [2]int{ax, ay})
			}
			ax += 1
			if !cx[x] {
				ax += mul - 1
			}
		}
		ax = 0
		ay += 1
		if !cy[y] {
			ay += mul - 1
		}
	}
	s := 0
	for i := 0; i < len(g); i++ {
		for j := i + 1; j < len(g); j++ {
			s += Abs(g[i][0]-g[j][0]) + Abs(g[i][1]-g[j][1])
		}
	}
	return s
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
