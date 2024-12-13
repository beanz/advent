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
	as := make([]int, 0, 1024)
	bs := make([]int, 0, 1024)
	for i := 0; i < len(in); {
		var j, a, b int
		j, a = ChompUInt[int](in, i)
		j, b = ChompUInt[int](in, j+3)
		i = j + 1
		as = append(as, a)
		bs = append(bs, b)
	}
	sort.Ints(as)
	sort.Ints(bs)
	p1 := 0
	for i := 0; i < len(as); i++ {
		p1 += Abs(as[i] - bs[i])
	}
	p2 := 0
	for ai, bi := 0, 0; ai < len(as) && bi < len(bs); {
		if as[ai] < bs[bi] {
			ai++
			continue
		}
		if as[ai] > bs[bi] {
			bi++
			continue
		}
		ac := 0
		v := as[ai]
		for ; ai < len(as) && as[ai] == v; ai++ {
			ac++
		}
		bc := 0
		for ; bi < len(bs) && bs[bi] == v; bi++ {
			bc++
		}
		p2 += v * ac * bc
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
