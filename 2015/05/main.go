package main

import (
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

func nice(s string) (bool, bool) {
	vc := 0
	hasDouble := false
	badPair := false
	dupPair := false
	sepRepeat := false
	for i := 0; i < len(s); i++ {
		if s[i] == 'a' || s[i] == 'e' || s[i] == 'i' || s[i] == 'o' || s[i] == 'u' {
			vc++
		}
		if i == len(s)-1 {
			continue
		}
		if s[i] == s[i+1] {
			hasDouble = true
		}
		if (s[i] == 'a' && s[i+1] == 'b') ||
			(s[i] == 'c' && s[i+1] == 'd') ||
			(s[i] == 'p' && s[i+1] == 'q') ||
			(s[i] == 'x' && s[i+1] == 'y') {
			badPair = true
		}
		if strings.Count(s, s[i:i+2]) >= 2 {
			dupPair = true
		}
		if i == len(s)-2 {
			continue
		}
		if s[i] == s[i+2] {
			sepRepeat = true
		}
	}
	return vc >= 3 && hasDouble && !badPair, dupPair && sepRepeat
}

func calc(in []string) (int, int) {
	c1 := 0
	c2 := 0
	for _, s := range in {
		p1, p2 := nice(s)
		if p1 {
			c1++
		}
		if p2 {
			c2++
		}
	}
	return c1, c2
}

func main() {
	in := ReadInputLines()
	p1, p2 := calc(in)
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
