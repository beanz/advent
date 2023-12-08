package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	i := 0
	for ; in[i] != '\n'; i++ {
	}
	steps := in[0:i]
	//fmt.Fprintf(os.Stderr, "%d\n", len(steps))
	i += 2
	g := make([]int, 0, 800)
	ml := make([]int, 26426)
	mr := make([]int, 26426)
	for i < len(in) {
		f, l, r := readID(in, i), readID(in, i+7), readID(in, i+12)
		//fmt.Fprintf(os.Stderr, "%s => %d %d %d\n", string(in[i:i+16]), f, l, r)
		if in[i+2] == 'A' {
			g = append(g, f)
		}
		ml[f] = l + 1 // add one so we can check for zeroes
		mr[f] = r + 1
		i += 17
	}
	mod := len(steps)
	run := func(p int) int {
		c := 0
		for {
			if steps[c%mod] == 'L' {
				p = ml[p]
			} else {
				p = mr[p]
			}
			if p == 0 {
				return 1
			}
			p--
			c++
			if (p & 0x1f) == 25 {
				return c
			}
		}
	}
	p1 := run(0)
	lcm := int64(p1)
	for _, p := range g {
		lcm = LCM(int64(run(p)), lcm)
	}

	return p1, int(lcm)
}

func readID(in []byte, i int) int {
	return (int(in[i]-'A') << 10) + (int(in[i+1]-'A') << 5) + int(in[i+2]-'A')
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
