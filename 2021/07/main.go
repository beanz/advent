package main

import (
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"math"
)

func Fuel(a, b int) int {
	return Abs(a - b)
}

func Fuel2(a, b int) int {
	f := Abs(a - b)
	return f * (f + 1) / 2
}

func MinFuel(inp []int, fn func(int, int) int) int {
	start := MinInt(inp...)
	end := MaxInt(inp...)
	min := math.MaxInt32
	for p := start; p <= end; p++ {
		c := 0
		for _, v := range inp {
			c += fn(p, v)
		}
		if min > c {
			min = c
		}
	}
	return min
}

func Part1(inp []int) int {
	return MinFuel(inp, Fuel)
}

func Part2(inp []int) int {
	return MinFuel(inp, Fuel2)
}

func main() {
	inp := ReadInputInts()
	fmt.Printf("Part 1: %d\n", Part1(inp))
	fmt.Printf("Part 2: %d\n", Part2(inp))
}
