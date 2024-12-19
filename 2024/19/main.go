package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	pat := []string{}
	i := 0
	j := 0
PL:
	for {
		switch in[i] {
		case ',':
			pat = append(pat, string(in[j:i]))
			i += 2
			j = i
		case '\n':
			pat = append(pat, string(in[j:i]))
			i += 2
			j = i
			break PL
		default:
			i++
		}
	}
	p1, p2 := 0, 0
	mem := make(map[string]int, 20000)
	mem[""] = 1
	for i < len(in) {
		if in[i] == '\n' {
			towel := string(in[j:i])
			j = i + 1
			if m := matches(pat, towel, mem); m != 0 {
				p1++
				p2 += m
			}
		}
		i++
	}
	return p1, p2
}

func matches(patterns []string, towel string, mem map[string]int) int {
	if v, ok := mem[towel]; ok {
		return v
	}
	c := 0
	// terminated by mem[""] = 1 entry so no condition needed here
	for _, pattern := range patterns {
		if after, found := strings.CutPrefix(towel, pattern); found {
			c += matches(patterns, after, mem)
		}
	}
	mem[towel] = c
	return c
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
