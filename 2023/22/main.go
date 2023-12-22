package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	bricks := make([][6]int, 0, 1210)
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
		if a[0] >= b[3] || b[0] >= a[3] {
			return false
		}
		if a[1] >= b[4] || b[1] >= a[4] {
			return false
		}
		if a[2] >= b[5] || b[2] >= a[5] {
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
	s := make([][]int, len(bricks))
	sc := make([]int, len(bricks))
	for i := 0; i < len(bricks); i++ {
		var r []int
		for bricks[i][2] > 1 {
			t := [6]int{bricks[i][0], bricks[i][1], bricks[i][2] - 1, bricks[i][3], bricks[i][4], bricks[i][5] - 1}
			r = allIntersects(i, t)
			if r != nil {
				break
			}
			bricks[i][2]--
			bricks[i][5]--
		}
		for _, j := range r {
			s[j] = append(s[j], i)
		}
		sc[i] = len(r)
	}
	p1, p2 := 0, 0
	for i := 0; i < len(bricks); i++ {
		dis := 0
		rem := make([]int, len(bricks))
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
