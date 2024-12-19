package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	pat := [][]byte{}
	i := 0
	j := 0
PL:
	for {
		switch in[i] {
		case ',':
			pat = append(pat, in[j:i])
			i += 2
			j = i
		case '\n':
			pat = append(pat, in[j:i])
			i += 2
			j = i
			break PL
		default:
			i++
		}
	}
	towels := [][]byte{}
	for i < len(in) {
		if in[i] == '\n' {
			towels = append(towels, in[j:i])
			j = i + 1
		}
		i++
	}
	p1, p2 := 0, 0
	mem := make(map[string]int, 20000)
	mem[""] = 1
	for _, towel := range towels {
		if m := matches(pat, towel, mem); m != 0 {
			p1++
			p2 += m
		}
	}
	return p1, p2
}

func matches(patterns [][]byte, towel []byte, mem map[string]int) int {
	if v, ok := mem[string(towel)]; ok {
		return v
	}
	c := 0
	// terminated by mem[""] = 1 entry so no condition needed here
	for _, pattern := range patterns {
		if after, found := bytes.CutPrefix(towel, pattern); found {
			c += matches(patterns, after, mem)
		}
	}
	mem[string(towel)] = c
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
