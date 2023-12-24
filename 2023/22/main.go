package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const SIZE = 1400

func Parts(in []byte, args ...int) (int, int) {
	bricks := make([][6]int, 0, SIZE)
	for i := 0; i < len(in); i++ {
		brick := [6]int{}
		j := 0
		VisitUints(in, '\n', &i, func(n int) {
			if j >= 3 {
				n++
			}
			brick[j] = n
			j++
		})
		bricks = append(bricks, brick)
	}
	sort.Slice(bricks, func(i, j int) bool {
		return bricks[i][2] < bricks[j][2]
	})
	intersected := func(a, b [6]int) bool {
		if a[2] >= b[5] || b[2] >= a[5] {
			return false
		}
		if a[1] >= b[4] || b[1] >= a[4] {
			return false
		}
		if a[0] >= b[3] || b[0] >= a[3] {
			return false
		}
		return true
	}
	allIntersects := func(i int, a [6]int) []int {
		var r []int
		for j := 0; j < len(bricks); j++ {
			if i == j {
				continue
			}
			if intersected(bricks[j], a) {
				r = append(r, j)
			}
		}
		return r
	}
	height := make([]int, 121)
	hiAt := func(x, y int) int {
		return height[x+11*y]
	}
	stopBrick := func(xmin, xmax, ymin, ymax int) int {
		z := 0
		for y := ymin; y < ymax; y++ {
			for x := xmin; x < xmax; x++ {
				h := hiAt(x, y)
				if h > z {
					z = h
				}
			}
		}
		return z
	}
	s := make([][]int, SIZE)
	sc := make([]int, SIZE)
	for i := 0; i < len(bricks); i++ {
		var r []int
		z := stopBrick(bricks[i][0], bricks[i][3], bricks[i][1], bricks[i][4]) + 1
		drop := bricks[i][2] - z
		bricks[i][2] = z
		bricks[i][5] -= drop
		t := [6]int{bricks[i][0], bricks[i][1], bricks[i][2] - 1, bricks[i][3], bricks[i][4], bricks[i][5] - 1}
		r = allIntersects(i, t)
		for y := bricks[i][1]; y < bricks[i][4]; y++ {
			for x := bricks[i][0]; x < bricks[i][3]; x++ {
				height[x+y*11] = bricks[i][5] - 1
			}
		}
		for _, j := range r {
			s[j] = append(s[j], i)
		}
		sc[i] = len(r)
	}
	p1, p2 := 0, 0
	for i := 0; i < len(bricks); i++ {
		dis := 0
		rem := make([]int, SIZE)
		todo := s[i]
		for len(todo) > 0 {
			cur := todo[0]
			todo = todo[1:]
			rem[cur]++
			if sc[cur] == rem[cur] {
				todo = append(todo, s[cur]...)
				dis++
			}
		}
		if dis == 0 {
			p1++
		}
		p2 += dis
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
