package main

import (
	"cmp"
	_ "embed"
	"fmt"
	"slices"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	ranges := [][2]int{}
	i := 0
	for ; i < len(in); i++ {
		if in[i] == '\n' {
			break
		}
		var s, e int
		i, s = ChompUInt[int](in, i)
		i, e = ChompUInt[int](in, i+1)
		ranges = append(ranges, [2]int{s, e + 1})
	}
	i++
	p1 := 0
	for ; i < len(in); i++ {
		var n int
		i, n = ChompUInt[int](in, i)
		for _, r := range ranges {
			if r[0] <= n && n < r[1] {
				p1++
				break
			}
		}
	}
	p2 := 0
	slices.SortFunc(ranges, func(a [2]int, b [2]int) int {
		return cmp.Compare(a[0], b[0])
	})
	end := 0
	for _, r := range ranges {
		if r[0] < end {
			r[0] = end
		}
		if r[0] < r[1] {
			p2 += r[1] - r[0]
		}
		end = max(r[1], end)
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
