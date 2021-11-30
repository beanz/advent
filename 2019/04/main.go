package main

import (
	"fmt"
	"log"
	//"math"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

func Count(s string, ch byte) int {
	c := 0
	for i := 0; i < len(s); i++ {
		if s[i] == ch {
			c++
		}
	}
	return c
}

func Part1(r []int) int {
	c := 0
	for i := r[0]; i <= r[1]; i++ {
		s := fmt.Sprintf("%d", i)
		if len(s) != 6 {
			continue
		}
		if s[0] > s[1] || s[1] > s[2] || s[2] > s[3] ||
			s[3] > s[4] || s[4] > s[5] {
			continue
		}
		for ch := 48; ch <= 57; ch++ {
			if Count(s, byte(ch)) >= 2 {
				c++
				break
			}
		}
	}
	return c
}

func Part2(r []int) int {
	c := 0
	for i := r[0]; i <= r[1]; i++ {
		s := fmt.Sprintf("%d", i)
		if len(s) != 6 {
			continue
		}
		if s[0] > s[1] || s[1] > s[2] || s[2] > s[3] ||
			s[3] > s[4] || s[4] > s[5] {
			continue
		}
		for ch := 48; ch <= 57; ch++ {
			if Count(s, byte(ch)) == 2 {
				c++
				break
			}
		}
	}
	return c
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	i := ReadInts(strings.Split(lines[0], "-"))
	fmt.Printf("Part 1: %d\n", Part1(i))
	fmt.Printf("Part 2: %d\n", Part2(i))
}
