package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

func Part1(e *ElfProg2018) int {
	c := 0
	return e.Run(func(e *ElfProg2018) bool {
		c++
		return c >= 10000000
	})
}

func Part2(e *ElfProg2018) int {
	e.Reg[0] = 1
	c := 0
	e.Run(func(e *ElfProg2018) bool {
		c++
		return c >= 100
	})
	s := 0
	for i := 1; i <= e.Reg[4]; i++ {
		if (e.Reg[4] % i) == 0 {
			s += i
		}
	}
	return s
}

func main() {
	e := NewElfProg2018(ReadInputLines())
	fmt.Printf("Part 1: %d\n", Part1(e))
	e = NewElfProg2018(ReadInputLines())
	fmt.Printf("Part 2: %d\n", Part2(e))
}
