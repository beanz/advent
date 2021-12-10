package main

import (
	_ "embed"
	"fmt"
	"gonum.org/v1/gonum/stat/combin"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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
	lines := InputLines(input)
	report := NewReport(lines)
	r := report.Solve(2020, 2)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", r)
	}
	r = report.Solve(2020, 3)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", r)
	}
}

var benchmark = false
