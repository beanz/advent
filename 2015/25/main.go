package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func SumSeries(first, last int) int {
	return (1 + last - first) * (first + last) / 2
}

func PosIndex(x, y int) int {
	return (y * (x - 1)) + SumSeries(1, x-2) + SumSeries(1, y)
}

func Seq(n int) int {
	return int((20151125 * ModExp(252533, uint(n)-1, 33554393)) % 33554393)
}

func calc(in []int) int {
	return Seq(PosIndex(in[0], in[1]))
}

func main() {
	p1 := calc(InputInts(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
}

var benchmark bool
