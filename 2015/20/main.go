package main

import (
	"fmt"
	"github.com/cznic/mathutil"

	. "github.com/beanz/advent/lib-go"
)

func NumPresents(house int, part2 bool) int {
	multi := 10
	if part2 {
		multi = 11
	}
	s := 1
	terms := mathutil.FactorInt(uint32(house))
	if len(terms) > 0 {
		ints := []int{}
		for _, term := range terms {
			for i := 0; i < int(term.Power); i++ {
				ints = append(ints, int(term.Prime))
			}
		}
		seen := make(map[int]bool)
		subsets := NewSubsets(len(ints))
		for ss := subsets.Get(); !subsets.Done(); ss = subsets.Next() {
			p := 1
			for _, i := range ss {
				p *= ints[i]
			}
			if part2 && house/p > 50 {
				continue
			}
			if seen[p] {
				continue
			}
			seen[p] = true
			s += p
		}
	}
	return s * multi
}

func calc(in int, part2 bool) int {
	for h := 0; ; h++ {
		n := NumPresents(h, part2)
		if n > in {
			return h
		}
	}
	return -1
}

func main() {
	in := ReadInputInts()[0]
	fmt.Printf("Part 1: %d\n", calc(in, false))
	fmt.Printf("Part 2: %d\n", calc(in, true))
}
