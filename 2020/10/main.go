package main

import (
	_ "embed"
	"fmt"
	"sort"

	aoc "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Part1(numbers []int) int {
	numbers = append(numbers, numbers[len(numbers)-1]+3)
	cj := 0
	c := make(map[int]int, 3)
	for _, j := range numbers {
		d := j - cj
		c[d]++
		cj = j
	}
	return c[1] * c[3]
}

func count(cj, tj int, jolts []int, state map[string]int64) int64 {
	k := fmt.Sprintf("%d!%d", cj, len(jolts))
	if v, ok := state[k]; ok {
		return v
	}
	//fmt.Printf("(%d) %v (%d)\n", cj, jolts, tj)
	if len(jolts) == 0 {
		state[k] = 1
		return state[k]
	}
	var c int64
	for len(jolts) > 0 {
		j := jolts[0]
		jolts = jolts[1:]
		if j-cj <= 3 {
			c += count(j, tj, jolts, state)
		}
	}
	state[k] = c
	return c
}

func Part2(numbers []int) int64 {
	state := make(map[string]int64, len(numbers))
	return count(0, numbers[len(numbers)-1], numbers, state)
}

func main() {
	numbers := aoc.InputInts(input)
	sort.Ints(numbers)
	p1 := Part1(numbers)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(numbers)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
