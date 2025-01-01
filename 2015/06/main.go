package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func calc(in []string) (int, int) {
	var l1 [1000 * 1000]bool
	var l2 [1000 * 1000]int
	for _, inst := range in {
		ints := Ints(inst)
		var fn func(int)
		switch inst[6] {
		case 'f':
			fn = func(i int) {
				l1[i] = false
				l2[i]--
				if l2[i] < 0 {
					l2[i] = 0
				}
			}
		case 'n':
			fn = func(i int) {
				l1[i] = true
				l2[i]++
			}
		default:
			fn = func(i int) {
				l1[i] = !l1[i]
				l2[i] += 2
			}
		}
		for x := ints[0]; x <= ints[2]; x++ {
			for y := ints[1]; y <= ints[3]; y++ {
				fn(x + 1000*y)
			}
		}
	}
	c1 := 0
	c2 := 0
	for i := range l2 {
		if l1[i] {
			c1++
		}
		c2 += l2[i]
	}
	return c1, c2
}

func main() {
	in := InputLines(input)
	p1, p2 := calc(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
