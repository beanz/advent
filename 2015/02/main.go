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
	var paper int
	var ribbon int
	back := [3]int{}
	for i := 0; i < len(in); i++ {
		dim := back[:0]
		VisitUints(in, '\n', &i, func(a int) {
			dim = append(dim, a)
		})
		sort.Ints(dim)
		p1 := dim[0] * dim[1]
		p2 := dim[0] * dim[2]
		p3 := dim[1] * dim[2]
		paper += 2 * (p1 + p2 + p3)
		paper += p1
		ribbon += 2 * (dim[0] + dim[1])
		ribbon += Product(dim...)
	}
	return paper, ribbon
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
