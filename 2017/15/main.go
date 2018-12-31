package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	generators := ReadGenerators(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", Part1(generators))
	fmt.Printf("Part 2: %d\n", Part2(generators))
}
