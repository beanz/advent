package main

import (
	"fmt"
	"regexp"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

var (
	finishedMatch  = regexp.MustCompile(`^(\d+)$`)
	tetheredPlus   = regexp.MustCompile(`^(\d+) \+ (\d+)`)
	tetheredMult   = regexp.MustCompile(`^(\d+) \* (\d+)`)
	untetheredPlus = regexp.MustCompile(`(\d+) \+ (\d+)`)
	bracketMatch   = regexp.MustCompile(`\(([^()]+)\)`)
)

func ReadNInt64s(s string, expected int, msg string) []int64 {
	nums := SimpleReadInt64s(s)
	if len(nums) != expected {
		panic(msg)
	}
	return nums
}

func Part1Math(s string) int64 {
	if DEBUG() {
		fmt.Printf("P1: %s\n", s)
	}
	if m := finishedMatch.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("Just number: %s\n", s)
		}
		nums := ReadNInt64s(m[0], 1, "invalid answer"+s)
		return nums[0]
	}
	if m := bracketMatch.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("(): %s => %s\n", s, m[1])
		}
		return Part1Math(strings.Replace(s,
			m[0], fmt.Sprintf("%d", Part1Math(m[1])), 1))
	}
	if m := tetheredPlus.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("+: %s => %s\n", s, m[0])
		}
		nums := ReadNInt64s(m[0], 2, "invalid + operands in "+m[0])
		return Part1Math(strings.Replace(s,
			m[0], fmt.Sprintf("%d", nums[0]+nums[1]), 1))
	}
	if m := tetheredMult.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("*: %s => %s\n", s, m[0])
		}
		nums := ReadNInt64s(m[0], 2, "invalid * operands in "+m[0])
		return Part1Math(strings.Replace(s,
			m[0], fmt.Sprintf("%d", nums[0]*nums[1]), 1))
	}
	return 1
}

func Part1(lines []string) int64 {
	var s int64
	for _, sum := range lines {
		s += Part1Math(sum)
	}
	return s
}

func Part2Math(s string) int64 {
	if DEBUG() {
		fmt.Printf("P1: %s\n", s)
	}
	if m := finishedMatch.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("Just number: %s\n", s)
		}
		nums := ReadNInt64s(m[0], 1, "invalid answer"+s)
		return nums[0]
	}
	if m := bracketMatch.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("(): %s => %s\n", s, m[1])
		}
		return Part2Math(strings.Replace(s,
			m[0], fmt.Sprintf("%d", Part2Math(m[1])), 1))
	}
	if m := untetheredPlus.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("+: %s => %s\n", s, m[0])
		}
		nums := ReadNInt64s(m[0], 2, "invalid + operands in "+m[0])
		return Part2Math(strings.Replace(s,
			m[0], fmt.Sprintf("%d", nums[0]+nums[1]), 1))
	}
	if m := tetheredMult.FindStringSubmatch(s); m != nil {
		if DEBUG() {
			fmt.Printf("*: %s => %s\n", s, m[0])
		}
		nums := ReadNInt64s(m[0], 2, "invalid * operands in "+m[0])
		return Part2Math(strings.Replace(s,
			m[0], fmt.Sprintf("%d", nums[0]*nums[1]), 1))
	}
	return 1
}

func Part2(lines []string) int64 {
	var s int64
	for _, sum := range lines {
		s += Part2Math(sum)
	}
	return s
}

func main() {
	lines := ReadInputLines()
	fmt.Printf("Part 1: %d\n", Part1(lines))
	fmt.Printf("Part 2: %d\n", Part2(lines))
}
