package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	seeds := make([]int, 0, 20)
	i := 0
	VisitUints[int](in, '\n', &i, func(n int) {
		seeds = append(seeds, n)
	})
	seed_ranges := make([][2]int, 0, 128)
	mapped := make([][2]int, 0, 128)
	for j := 0; j < len(seeds); j += 2 {
		seed_ranges = append(seed_ranges, [2]int{seeds[j], seeds[j] + seeds[j+1]})
	}
	i += 2
	for i < len(in) {
		for in[i] != '\n' {
			i++
		}

		tf := make([][3]int, 0, 64)
		for i++; i <= len(in); i++ {
			s := [3]int{}
			j := 0
			VisitUints[int](in, '\n', &i, func(n int) {
				s[j] = n
				j++
			})
			tf = append(tf, s)
			if i+1 >= len(in) || in[i+1] == '\n' {
				break
			}
		}
		i++
		for j := range seeds {
			for _, r := range tf {
				if r[1] <= seeds[j] && seeds[j] < r[1]+r[2] {
					seeds[j] = r[0] + (seeds[j] - r[1])
					break
				}
			}
		}
	OUTER:
		for len(seed_ranges) > 0 {
			cur := seed_ranges[0]
			seed_ranges = seed_ranges[1:]
			start, end := cur[0], cur[1]
			for _, r := range tf {
				dst, src, src_end := r[0], r[1], r[1]+r[2]
				before_start := start
				before_end := Min(end, src)
				overlap_start := Max(start, src)
				overlap_end := Min(src_end, end)
				after_start := Max(src_end, start)
				after_end := end
				if overlap_end > overlap_start {
					mapped = append(mapped, [2]int{overlap_start + dst - src, overlap_end + dst - src})
				} else {
					continue
				}
				if before_end > before_start {
					seed_ranges = append(seed_ranges, [2]int{before_start, before_end})
				}
				if after_end > after_start {
					seed_ranges = append(seed_ranges, [2]int{after_start, after_end})
				}
				continue OUTER
			}
			mapped = append(mapped, [2]int{start, end})
		}
		mapped, seed_ranges = seed_ranges, mapped
	}
	sort.Ints(seeds)
	sort.Slice(seed_ranges, func(i, j int) bool { return seed_ranges[i][0] < seed_ranges[j][0] })
	return seeds[0], seed_ranges[0][0]
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
