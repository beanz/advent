package main

import (
	"fmt"

	. "github.com/beanz/advent2015/lib"
)

type Point struct {
	x, y int
}

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
			p1p.y--
			p1[p1p] = true
			p2p[i%2].y--
			p2[p2p[i%2]] = true
		case '>':
			p1p.x++
			p1[p1p] = true
			p2p[i%2].x++
			p2[p2p[i%2]] = true
		case 'v':
			p1p.y++
			p1[p1p] = true
			p2p[i%2].y++
			p2[p2p[i%2]] = true
		case '<':
			p1p.x--
			p1[p1p] = true
			p2p[i%2].x--
			p2[p2p[i%2]] = true
		}
	}
	return len(p1), len(p2)
}

func main() {
	s := ReadInputLines()
	p1, p2 := calc(s)
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
