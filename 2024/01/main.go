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
	a := make([]int, 0, 1024)
	b := make([]int, 0, 1024)
	for i := 0; i < len(in); {
		var n int
		i, n = ChompUInt[int](in, i)
		a = append(a, n)
		for ; in[i] == ' '; i++ {
		}
		i, n = ChompUInt[int](in, i)
		b = append(b, n)
		i++
	}
	sort.Ints(a)
	sort.Ints(b)
	p1 := 0
	for i := 0; i < len(a); i++ {
		p1 += Abs(a[i] - b[i])
	}
	p2 := 0
	for ai, bi := 0, 0; ai < len(a) && bi < len(b); {
		if a[ai] < b[bi] {
			ai++
			continue
		}
		if a[ai] > b[bi] {
			bi++
			continue
		}
		ac := 0
		v := a[ai]
		for ; ai < len(a) && a[ai] == v; ai++ {
			ac++
		}
		bc := 0
		for ; bi < len(b) && b[bi] == v; bi++ {
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
