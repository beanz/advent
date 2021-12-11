package main

import (
	_ "embed"
	"fmt"
	"math"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func SolveAux(in []int, sum int) [][]int {
	minLen := math.MaxInt32
	res := [][]int{}
	for i := 0; i < len(in); i++ {
		if in[i] == sum {
			return [][]int{[]int{in[i]}}
		} else if in[i] > sum {
			continue
		}
		sol := SolveAux(in[i+1:], sum-in[i])
		if len(sol) > 0 {
			if len(sol[0]) > minLen {
				continue
			}
			if len(sol[0]) < minLen {
				minLen = len(sol[0])
				res = [][]int{}
			}
			for _, ss := range sol {
				s := make([]int, len(ss)+1)
				copy(s[1:], ss)
				s[0] = in[i]
				res = append(res, s)
			}
		}
	}
	return res
}

func Solve(in []int, groups int) int {
	sort.Sort(sort.Reverse(sort.IntSlice(in)))
	sum := Sum(in...)
	target := sum / groups
	sol := SolveAux(in, target)
	min := uint64(math.MaxUint64)
	for _, s := range sol {
		p := uint64(1)
		for _, v := range s {
			p *= uint64(v)
		}
		if p < uint64(min) {
			min = p
		}
	}
	return int(min)
}

func Part1(in []int) int {
	return Solve(in, 3)
}

func Part2(in []int) int {
	return Solve(in, 4)
}

func main() {
	p1 := Part1(InputInts(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(InputInts(input))
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
