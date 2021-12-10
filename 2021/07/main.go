package main

import (
	_ "embed"
	"fmt"
	"sort"

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

func MedianOfMedians(inp []int, n int) int {
	if len(inp) <= 10 {
		return SimpleMedianN(inp, n)
	}

	numSlices := (len(inp) + 4) / 5
	meds := make([]int, numSlices)
	for i := 0; i < numSlices; i++ {
		start := i * 5
		end := start + 5
		if end > len(inp) {
			end = len(inp)
		}
		sort.Ints(inp[start:end])
		meds[i] = inp[(start+end)/2]
	}
	pivot := MedianOfMedians(meds, len(meds)/2)
	var lhs, equal, rhs []int
	for i := range inp {
		if inp[i] < pivot {
			lhs = append(lhs, inp[i])
		} else if inp[i] > pivot {
			rhs = append(rhs, inp[i])
		} else {
			equal = append(equal, inp[i])
		}
	}
	if n < len(lhs) {
		return MedianOfMedians(lhs, n)
	} else if n < len(lhs)+len(equal) {
		return pivot
	}
	return MedianOfMedians(rhs, n-len(lhs)-len(equal))
}

func SimpleMedianN(inp []int, n int) int {
	sort.Ints(inp)
	return inp[n]
}

func SimpleMedian(inp []int) int {
	sort.Ints(inp)
	return inp[len(inp)/2]
}

func MinFuel1(inp []int) int {
	return FuelSum1(MedianOfMedians(inp, len(inp)/2), inp)
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
	inp := InputInts(input)
	p1, p2 := Calc(inp)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
