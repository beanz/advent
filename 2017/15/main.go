package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func ReadGenerators(lines []string) []int {
	return []int{
		SimpleReadInts(lines[0])[0],
		SimpleReadInts(lines[1])[0],
	}
}

func Generator(init int, factor int) func() int {
	p := init
	return func() int {
		p = (p * factor) % 2147483647
		return p
	}
}

func MultipleGenerator(init int, factor int, mul int) func() int {
	f := Generator(init, factor)
	return func() int {
		var n int
		for {
			n = f()
			if (n % mul) == 0 {
				break
			}
		}
		return n
	}
}

func Part1(g []int) int {
	genA := Generator(g[0], 16807)
	genB := Generator(g[1], 48271)
	count := 0
	for i := 0; i < 40000000; i++ {
		vA := genA()
		vB := genB()
		//fmt.Printf("%12d %12d\n", vA, vB)
		if (vA & 0xffff) == (vB & 0xffff) {
			count++
		}
	}
	return count
}

func Part2(g []int) int {
	genA := MultipleGenerator(g[0], 16807, 4)
	genB := MultipleGenerator(g[1], 48271, 8)
	count := 0
	for i := 0; i < 5000000; i++ {
		vA := genA()
		vB := genB()
		//fmt.Printf("%12d %12d\n", vA, vB)
		if (vA & 0xffff) == (vB & 0xffff) {
			count++
		}
	}
	return count
}

func main() {
	generators := ReadGenerators(InputLines(input))
	p1 := Part1(generators)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(generators)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
