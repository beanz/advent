package main

import (
	"fmt"
	"github.com/cznic/mathutil"

	. "github.com/beanz/advent2015/lib"
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
		for _, ss := range Subsets(len(ints) - 1) {
			if len(ss) > 0 {
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

func Subsets(n int) [][]int {
	if n == 0 {
		return [][]int{[]int{0}, []int{}}
	}
	res := Subsets(n - 1)
	l := len(res)
	for i := 0; i < l; i++ {
		inc := make([]int, len(res[i])+1)
		inc[0] = n
		copy(inc[1:], res[i])
		res = append(res, inc)
	}
	return res
}
