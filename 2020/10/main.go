package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"

	aoc "github.com/beanz/advent/lib-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	b, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatalf("Failed to read input, %s: %s\n", os.Args[1], err)
	}
	numbers := aoc.SimpleReadInts(string(b))
	sort.Ints(numbers)

	fmt.Printf("Part 1: %d\n", Part1(numbers))
	fmt.Printf("Part 2: %d\n", Part2(numbers))
}
