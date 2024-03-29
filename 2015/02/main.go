package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func calc(in []string) (int, int) {
	var paper int
	var ribbon int
	for _, l := range in {
		dim := Ints(l)
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
	s := InputLines(input)
	p1, p2 := calc(s)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
