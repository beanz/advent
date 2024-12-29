package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1 := 0
	p2 := [1048576]int{}
	mx := 0
	for i := 0; i < len(in); {
		var n int
		i, n = ChompUInt[int](in, i)
		i++
		prevPrice := n % 10
		k := 0
		seen := [1048576]bool{}
		for j := 0; j < 2000; j++ {
			n ^= n << 6
			n &= 0xffffff
			n ^= n >> 5
			n &= 0xffffff
			n ^= n << 11
			n &= 0xffffff
			price := n % 10
			diff := (price - prevPrice) & 0x1f
			prevPrice = price
			k = ((k << 5) + diff) & 0xfffff
			if j < 4 || seen[k] {
				continue
			}
			seen[k] = true
			p2[k] += price
			if p2[k] > mx {
				mx = p2[k]
			}
		}
		p1 += n
	}
	return p1, mx
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
