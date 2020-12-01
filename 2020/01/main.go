package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Report struct {
	e     []int
	debug bool
}

func (r *Report) String() string {
	return fmt.Sprintf("%v", r.e)
}

func NewReport(lines []string) *Report {
	e, err := ReadInts(lines)
	if err != nil {
		panic(err)
	}
	return &Report{e, false}
}

func (r *Report) Part1() int {
	for i := 0; i < len(r.e); i++ {
		for j := i; j < len(r.e); j++ {
			if r.e[i]+r.e[j] == 2020 {
				return r.e[i] * r.e[j]
			}
		}
	}
	return 0
}

func (r *Report) Part2() int {
	for i := 0; i < len(r.e); i++ {
		for j := i; j < len(r.e); j++ {
			for k := j; k < len(r.e); k++ {
				if r.e[i]+r.e[j]+r.e[k] == 2020 {
					return r.e[i] * r.e[j] * r.e[k]
				}
			}
		}
	}
	return 0
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	report := NewReport(lines)
	//fmt.Print("%s\n", report)
	fmt.Printf("Part 1: %d\n", report.Part1())
	fmt.Printf("Part 2: %d\n", report.Part2())
}
