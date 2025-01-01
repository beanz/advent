package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1 := make(map[Point]struct{}, 2700)
	p2 := make(map[Point]struct{}, 2700)
	p1p := Point{X: 0, Y: 0}
	p2p := []Point{{X: 0, Y: 0}, {X: 0, Y: 0}}
	p1[p1p] = struct{}{}
	p2[p2p[0]] = struct{}{}
	for i, ch := range in {
		switch ch {
		case '^':
			p1p.Y--
			p2p[i%2].Y--
		case '>':
			p1p.X++
			p2p[i%2].X++
		case 'v':
			p1p.Y++
			p2p[i%2].Y++
		case '<':
			p1p.X--
			p2p[i%2].X--
		}
		p1[p1p] = struct{}{}
		p2[p2p[i%2]] = struct{}{}
	}
	return len(p1), len(p2)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
