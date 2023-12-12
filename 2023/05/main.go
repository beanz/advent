package main

import (
	_ "embed"
	"fmt"
	"os"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	seeds := make([]int, 0, 20)
	i := 0
	VisitUints[int](in, '\n', &i, func(n int) {
		seeds = append(seeds, n)
	})
	seed_ranges := make([][2]int, 0, 10)
	for j := 0; j < len(seeds); j += 2 {
		seed_ranges = append(seed_ranges, [2]int{seeds[j], seeds[j+1]})
	}
	i += 2
	for i < len(in) {
		for in[i] != '\n' {
			i++
		}

		tf := make([][3]int, 0, 64)
		for i++; i <= len(in); i++ {
			fmt.Fprintf(os.Stderr, "I: %s\n", string(in[i:i+3]))
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
		fmt.Fprintf(os.Stderr, "%v\n", seeds)
	}
	sort.Ints(seeds)
	return seeds[0], 2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
