package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

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

type sortRunes []rune

func (s sortRunes) Less(i, j int) bool {
	return s[i] < s[j]
}

func (s sortRunes) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s sortRunes) Len() int {
	return len(s)
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}

	fmt.Printf("Part 1: %d\n", Part1(ReadLines(os.Args[1])))
	fmt.Printf("Part 2: %d\n", Part2(ReadLines(os.Args[1])))
}
