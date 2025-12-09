package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	points := make([]point, 0, 512)
	mx := 0
	my := 0
	for i := 0; i < len(in); i++ {
		var x, y int
		i, x = ChompUInt[int](in, i)
		i, y = ChompUInt[int](in, i+1)
		if len(points) > 0 {
			o := points[len(points)-1]
			dx := Abs(o.x - x)
			if mx < dx {
				mx = dx
				my = o.y
			}
		}
		points = append(points, point{x, y})
	}
	p1, p2 := 0, 0
	for i := 0; i < len(points); i++ {
	LOOP:
		for j := i + 1; j < len(points); j++ {
			dx := 1 + Abs(points[i].x-points[j].x)
			dy := 1 + Abs(points[i].y-points[j].y)
			a := dx * dy
			p1 = max(p1, a)
			if a < p2 {
				// avoid expensive check if area is too small anyway
				continue
			}
			if mx > 1000 && (points[i].y < my && points[j].y >= my || points[i].y > my && points[j].y <= my) {
				continue
			}
			minX := min(points[i].x, points[j].x)
			maxX := max(points[i].x, points[j].x)
			minY := min(points[i].y, points[j].y)
			maxY := max(points[i].y, points[j].y)
			for k := 0; k < len(points); k++ {
				if k == i || k == j {
					continue
				}
				l := (k + 1) % len(points)
				if l == i || l == j {
					continue
				}
				minXl := min(points[k].x, points[l].x)
				maxXl := max(points[k].x, points[l].x)
				minYl := min(points[k].y, points[l].y)
				maxYl := max(points[k].y, points[l].y)
				if !(maxXl <= minX || maxX <= minXl || maxYl <= minY || maxY <= minYl) {
					continue LOOP
				}
			}
			p2 = a
		}
	}

	return p1, p2
}

type point struct{ x, y int }

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
