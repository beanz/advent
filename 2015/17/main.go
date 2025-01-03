package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func calc(in []int, target int) (int, int) {
	c1 := 0
	min := math.MaxInt32
	c2 := 0
	subsets := NewSubsets(len(in))
	for ss := subsets.Get(); !subsets.Done(); ss = subsets.Next() {
		t := 0
		for _, i := range ss {
			t += in[i]
		}
		if t == target {
			c1++
			if len(ss) < min {
				min = len(ss)
				c2 = 1
			} else if len(ss) == min {
				c2++
			}
		}
	}
	return c1, c2
}

func main() {
	file := InputFile()
	in := InputInts(input)
	target := 150
	if file == "test1.txt" {
		target = 25
	}
	p1, p2 := calc(in, target)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
