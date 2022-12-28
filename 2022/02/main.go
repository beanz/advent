package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int int32

func Parts(inp []byte) (Int, Int) {
	var p1 Int
	var p2 Int
	s1 := []Int{0, 0, 0, 0, 4, 8, 3, 0, 1, 5, 9, 0, 7, 2, 6}
	s2 := []Int{0, 0, 0, 0, 3, 4, 8, 0, 1, 5, 9, 0, 2, 6, 7}
	for i := 0; i < len(inp); i += 4 {
		j := Int(inp[i]&0x3)<<2 + Int(inp[i+2]&0x3)
		p1 += s1[j]
		p2 += s2[j]
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
