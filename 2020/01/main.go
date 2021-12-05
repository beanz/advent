package main

import (
	"fmt"
	"gonum.org/v1/gonum/stat/combin"

	. "github.com/beanz/advent/lib-go"
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
	return &Report{ReadInts(lines), false}
}

func (r *Report) Part1() int {
	return r.Solve(2020, 2)
}

func (r *Report) Part2() int {
	return r.Solve(2020, 3)
}

func main() {
	lines := ReadInputLines()
	report := NewReport(lines)
	//fmt.Print("%s\n", report)
	fmt.Printf("Part 1: %d\n", report.Solve(2020, 2))
	fmt.Printf("Part 2: %d\n", report.Solve(2020, 3))
}
