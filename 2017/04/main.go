package main

import (
	_ "embed"
	"fmt"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func IsValid(words []string) bool {
	seen := map[string]bool{}
	for _, word := range words {
		if seen[word] {
			return false
		}
		seen[word] = true
	}
	return true
}

func Part1(lines []string) int {
	count := 0
	for _, l := range lines {
		if IsValid(strings.Split(l, " ")) {
			count++
		}
	}
	return count
}

func sortWord(s string) string {
	ss := strings.Split(s, "")
	sort.Strings(ss)
	return strings.Join(ss, "")
}

func IsValid2(words []string) bool {
	sorted := []string{}
	for _, w := range words {
		sorted = append(sorted, sortWord(w))
	}
	return IsValid(sorted)
}

func Part2(lines []string) int {
	count := 0
	for _, l := range lines {
		if IsValid2(strings.Split(l, " ")) {
			count++
		}
	}
	return count
}

func main() {
	lines := InputLines(input)
	p1 := Part1(lines)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(lines)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
