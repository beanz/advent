package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type rec struct {
	x, y int
	z    byte
}

func Parts(in []byte, args ...int) (int, int) {
	w := 0
	for ; in[w] != '\n'; w++ {
	}
	h := len(in) / (w + 1)
	p1, p2 := 0, 0
	get := func(x, y int) byte {
		if 0 <= x && x < w && 0 <= y && y < h {
			return in[x+y*(w+1)]
		}
		return '.'
	}
	score := func(x, y int, z byte) int {
		sc := 0
		todo := []rec{{x, y, z}}
		seen := make([]bool, len(in))
		for len(todo) > 0 {
			x, y, z := todo[0].x, todo[0].y, todo[0].z
			todo = todo[1:]
			if seen[x+y*(w+1)] {
				continue
			}
			seen[x+y*(w+1)] = true
			if z == '9' {
				sc++
				continue
			}
			if get(x, y-1) == z+1 {
				todo = append(todo, rec{x, y - 1, z + 1})
			}
			if get(x+1, y) == z+1 {
				todo = append(todo, rec{x + 1, y, z + 1})
			}
			if get(x, y+1) == z+1 {
				todo = append(todo, rec{x, y + 1, z + 1})
			}
			if get(x-1, y) == z+1 {
				todo = append(todo, rec{x - 1, y, z + 1})
			}
		}
		return sc
	}
	var rank func(x, y int, z byte) int
	rank = func(x, y int, z byte) int {
		r := 0
		if z == '9' {
			return 1
		}
		if get(x, y-1) == z+1 {
			r += rank(x, y-1, z+1)
		}
		if get(x+1, y) == z+1 {
			r += rank(x+1, y, z+1)
		}
		if get(x, y+1) == z+1 {
			r += rank(x, y+1, z+1)
		}
		if get(x-1, y) == z+1 {
			r += rank(x-1, y, z+1)
		}
		return r
	}
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			if in[x+y*(w+1)] == '0' {
				p1 += score(x, y, '0')
				p2 += rank(x, y, '0')
			}
		}
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
