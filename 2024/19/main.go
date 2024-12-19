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
	pat := make([][]byte, 0, 512)
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
	p1, p2 := 0, 0
	ways := [61]int{}
	for i < len(in) {
		if in[i] == '\n' {
			towel := in[j:i]
			j = i + 1
			if m := matches(pat, towel, ways); m != 0 {
				p1++
				p2 += m
			}
		}
		i++
	}
	return p1, p2
}

func matches(patterns [][]byte, towel []byte, ways [61]int) int {
	for i := 0; i < len(towel); i++ {
		ways[i+1] = 0
	}
	ways[0] = 1
	for i := 0; i < len(towel); i++ {
		if ways[i] == 0 {
			continue
		}
		for _, pattern := range patterns {
			l := len(pattern)
			if len(towel[i:]) >= l && bytes.Equal(towel[i:i+l], pattern) {
				ways[i+l] += ways[i]
			}
		}
	}
	return ways[len(towel)]
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
