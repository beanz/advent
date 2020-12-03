package main

import (
	"fmt"
	"log"
	"os"

	"gonum.org/v1/gonum/stat/combin"

	. "github.com/beanz/advent-of-code-go"
)

type Report struct {
	e     []int
	debug bool
}

func (r *Report) String() string {
	return fmt.Sprintf("%v", r.e)
}

func (r *Report) Solve(t int, k int) int {
	gen := combin.NewCombinationGenerator(len(r.e), k)
	for gen.Next() {
		s := 0
		p := 1
		for _, i := range gen.Combination(nil) {
			s += r.e[i]
			p *= r.e[i]
		}
		if s == t {
			return p
		}
	}
	return 0
}

func NewReport(lines []string) *Report {
	e, err := ReadInts(lines)
	if err != nil {
		panic(err)
	}
	return &Report{e, false}
}

func (r *Report) Part1() int {
	return r.Solve(2020, 2)
}

func (r *Report) Part2() int {
	return r.Solve(2020, 3)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	report := NewReport(lines)
	//fmt.Print("%s\n", report)
	fmt.Printf("Part 1: %d\n", report.Solve(2020, 2))
	fmt.Printf("Part 2: %d\n", report.Solve(2020, 3))
}
