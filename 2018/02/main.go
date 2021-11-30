package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

func stringContainsRepeats(s string, n int) bool {
	for i := 0; i <= len(s)-n; i++ {
		if strings.Count(s, string(s[i])) == n {
			return true
		}
	}
	return false
}

func Part1(lines []string) int {
	c2, c3 := 0, 0
	for _, line := range lines {
		if stringContainsRepeats(line, 2) {
			c2++
		}
		if stringContainsRepeats(line, 3) {
			c3++
		}
	}
	return c2 * c3
}

func commonCharacters(l1 string, l2 string) string {
	r := ""
	for i := 0; i < len(l1); i++ {
		if l1[i] == l2[i] {
			r += string(l1[i])
		}
	}
	return r
}

func Part2(lines []string) string {
	for i := 0; i < len(lines); i++ {
		for j := i + 1; j < len(lines); j++ {
			common := commonCharacters(lines[i], lines[j])
			if len(common) == len(lines[i])-1 {
				return common
			}
		}
	}
	return ""
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", Part1(lines))
	fmt.Printf("Part 2: %s\n", Part2(lines))
}
