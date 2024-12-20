package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

var patterns = [16777216]bool{}

func Parts(in []byte, args ...int) (int, int) {
	i := 0
	pat := 0
PL:
	for {
		switch in[i] {
		case ',':
			patterns[pat] = true
			pat = 0
			i += 2
		case '\n':
			patterns[pat] = true
			i += 2
			break PL
		default:
			pat = (pat << 3) + col(in[i])
			i++
		}
	}
	ways := [61]int{}
	matches := func(towel []byte) int {
		for i := 0; i < len(towel); i++ {
			ways[i+1] = 0
		}
		ways[0] = 1
		for i := 0; i < len(towel); i++ {
			if ways[i] == 0 {
				continue
			}
			t := 0
			for j := 0; j < 8; j++ {
				if i+j >= len(towel) {
					break
				}
				t = (t << 3) + col(towel[i+j])
				if patterns[t] {
					ways[i+j+1] += ways[i]
				}
			}
		}
		return ways[len(towel)]
	}
	p1, p2 := 0, 0
	j := i
	for i < len(in) {
		if in[i] == '\n' {
			towel := in[j:i]
			j = i + 1
			if m := matches(towel); m != 0 {
				p1++
				p2 += m
			}
		}
		i++
	}
	return p1, p2
}

func col(ch byte) int {
	switch ch {
	case 'b':
		return B
	case 'g':
		return G
	case 'r':
		return R
	case 'u':
		return U
	case 'w':
		return W
	}
	panic("invalid color?")
}

const (
	B = iota + 1
	G
	R
	U
	W
)

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
