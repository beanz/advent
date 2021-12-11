package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func calc(in []string) (int, int) {
	p1 := make(map[Point]bool, 2700)
	p2 := make(map[Point]bool, 2700)
	p1p := Point{0, 0}
	p2p := []Point{Point{0, 0}, Point{0, 0}}
	p1[p1p] = true
	p2[p2p[0]] = true
	for i, ch := range in[0] {
		switch ch {
		case '^':
			p1p.Y--
			p1[p1p] = true
			p2p[i%2].Y--
			p2[p2p[i%2]] = true
		case '>':
			p1p.X++
			p1[p1p] = true
			p2p[i%2].X++
			p2[p2p[i%2]] = true
		case 'v':
			p1p.Y++
			p1[p1p] = true
			p2p[i%2].Y++
			p2[p2p[i%2]] = true
		case '<':
			p1p.X--
			p1[p1p] = true
			p2p[i%2].X--
			p2[p2p[i%2]] = true
		}
	}
	return len(p1), len(p2)
}

func main() {
	s := InputLines(input)
	p1, p2 := calc(s)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
