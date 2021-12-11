package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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
	return FuelSum1(SimpleMedianN(inp, len(inp)/2), inp)
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
	return MinFuel1(inp), MinFuel2(inp)
}

func main() {
	inp := InputBytes(input)
	ints := FastInts(inp, 1024)
	p1, p2 := Calc(ints)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
