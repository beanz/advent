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
	seen_back := [1048576]byte{}
	seen := NewReuseableSeen(seen_back[:])
	mx := 0
	for n := range IterUInts[int](in) {
		prevPrice := n % 10
		k := 0
		next := func() int {
			n ^= n << 6
			n &= 0xffffff
			n ^= n >> 5
			n &= 0xffffff
			n ^= n << 11
			n &= 0xffffff
			return n % 10
		}
		for j := 0; j < 4; j++ {
			price := next()
			diff := (price - prevPrice) & 0x1f
			prevPrice = price
			k = ((k << 5) + diff) & 0xfffff
		}
		for j := 4; j < 2000; j++ {
			price := next()
			diff := (price - prevPrice) & 0x1f
			prevPrice = price
			k = ((k << 5) + diff) & 0xfffff
			if seen.HaveSeen(k) {
				continue
			}
			p2[k] += price
			if p2[k] > mx {
				mx = p2[k]
			}
		}
		p1 += n
		seen.Reset()
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
