package main

import (
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

func Fuel1(a, b int) int {
	return Abs(a - b)
}

func Fuel2(a, b int) int {
	f := Abs(a - b)
	return f * (f + 1) / 2
}

func FuelSum1(p int, inp []int) int {
	c := 0
	for _, v := range inp {
		c += Fuel1(p, v)
	}
	return c
}

func MinFuel1(inp []int) int {
	return FuelSum1(inp[len(inp)/2], inp)
}

func FuelSum2(p int, inp []int) int {
	c := 0
	for _, v := range inp {
		c += Fuel2(p, v)
	}
	return c
}

func MinFuel2(inp []int) int {
	mean := inp[0]
	for i := 1; i < len(inp); i++ {
		mean += inp[i]
	}
	mean /= len(inp)
	min := FuelSum2(mean, inp)
	c := FuelSum2(mean+1, inp)
	if min > c {
		min = c
	}
	return min
}

func Calc(inp []int) (int, int) {
	sort.Ints(inp)
	return MinFuel1(inp), MinFuel2(inp)
}

func main() {
	inp := ReadInputInts()
	p1, p2 := Calc(inp)
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
