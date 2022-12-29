package main

import (
	_ "embed"
	"fmt"
	"math/bits"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (uint32, uint32) {
	p1 := Part(in, 4)
	return p1, Part(in, 14)
}

func Part(in []byte, l int) uint32 {
	var n uint32
	for i := 0; i < len(in); i++ {
		n ^= 1 << uint32(in[i]&0x1f)
		if i < l {
			continue
		}
		n ^= 1 << uint32(in[i-l]&0x1f)
		if bits.OnesCount32(n) == l {
			return uint32(i + 1)
		}
	}
	return 1
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
