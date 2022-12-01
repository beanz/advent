package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	p1, p2 int
}

func Parts(inp []byte) (int, int) {
	sums := make([]int, 0, 256)
	var s int
	var n int
	eol := false
	for _, ch := range inp {
		switch ch {
		case '\n':
			if eol {
				sums = append(sums, s)
				s = 0
				eol = false
			} else {
				s += n
				n = 0
				eol = true
			}
		default:
			eol = false
			n = 10*n + int(ch-'0')
		}
	}
	sort.Slice(sums, func(i, j int) bool { return sums[i] > sums[j] })
	return sums[0], sums[0] + sums[1] + sums[2]
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
