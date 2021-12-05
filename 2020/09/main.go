package main

import (
	"fmt"
	"math"

	aoc "github.com/beanz/advent/lib-go"
)

func Part1(numbers []int64, pre int64) int64 {
	for i := pre; i < int64(len(numbers)); i++ {
		target := numbers[i]
		valid := false
		start := i - pre
		end := i
		for j := start; j <= end; j++ {
			for k := j; k <= end; k++ {
				if (numbers[j] + numbers[k]) == target {
					valid = true
				}
			}
		}
		if !valid {
			return target
		}
	}
	return 0
}

func Part2(numbers []int64, part1 int64) int64 {
	for n := 1; n < len(numbers); n++ {
		for i := 0; i < len(numbers)-n; i++ {
			s := int64(0)
			min := int64(math.MaxInt64)
			max := int64(math.MinInt64)
			for j := i; j <= i+n; j++ {
				if numbers[j] < min {
					min = numbers[j]
				}
				if numbers[j] > max {
					max = numbers[j]
				}
				s += numbers[j]
			}
			if s == part1 {
				return min + max
			}
		}
	}
	return 0
}

func main() {
	b := aoc.ReadInputBytes()
	numbers := aoc.SimpleReadInt64s(string(b))
	part1 := Part1(numbers, 25)
	fmt.Printf("Part 1: %d\n", part1)
	fmt.Printf("Part 2: %d\n", Part2(numbers, part1))
}
