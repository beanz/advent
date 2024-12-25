package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	keys := make([][5]int, 0, 512)
	locks := make([][5]int, 0, 512)
	for i := 0; i < len(in); i += 43 {
		j := i + 6
		c := [5]int{}
		for k := 0; k < 5; k++ {
			for l := 0; l < 5; l++ {
				if in[j+k+l*6] == '#' {
					c[k]++
				}
			}
		}
		if in[i] != '#' {
			locks = append(locks, c)
		} else {
			keys = append(keys, c)
		}
	}
	p1 := 0
	for _, lock := range locks {
		for _, key := range keys {
			if lock[0]+key[0] < 6 && lock[1]+key[1] < 6 && lock[2]+key[2] < 6 && lock[3]+key[3] < 6 && lock[4]+key[4] < 6 {
				p1++
			}
		}
	}
	return p1, 0
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
