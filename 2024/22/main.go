package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type P struct {
	price, diff int
}

func Parts(in []byte, args ...int) (int, int) {
	prices := []P{}
	p1 := 0
	p2 := map[[4]int]int{}
	for i := 0; i < len(in); {
		var n int
		i, n = ChompUInt[int](in, i)
		i++
		prevPrice := n % 10
		prices = prices[:0]
		for j := 0; j < 2000; j++ {
			n ^= n << 6
			n &= 0xffffff
			n ^= n >> 5
			n &= 0xffffff
			n ^= n << 11
			n %= 16777216
			n &= 0xffffff
			price := n % 10
			prices = append(prices, P{price: price, diff: price - prevPrice})
			prevPrice = price
		}
		p1 += n
		seen := map[[4]int]bool{}
		for j := 0; j < len(prices)-4; j++ {
			k := [4]int{prices[j].diff, prices[j+1].diff, prices[j+2].diff, prices[j+3].diff}
			if seen[k] {
				continue
			}
			seen[k] = true
			p2[k] += prices[j+3].price
		}
	}
	mx := 0
	for _, v := range p2 {
		if v > mx {
			mx = v
		}
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
