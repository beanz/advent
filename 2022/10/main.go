package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, [246]byte) {
	inc := [512]int{}
	i := 0
	j := 0
	for i < len(in) {
		j++
		if in[i] == 'a' {
			var k int
			if in[i+5] == '-' {
				k, inc[j] = NextUInt(in, i+6)
				inc[j] *= -1
			} else {
				k, inc[j] = NextUInt(in, i+5)
			}
			i = k + 1
			j++
		} else {
			i = i + 5
		}
	}
	num := j
	x := 1
	// i is sig index
	j = 0   // j = i%40
	k := 0  // k = inc index
	bi := 0 // p2 buffer index
	p1 := 0
	p2 := [246]byte{}
	for i = 0; i < 240; i++ {
		if x >= j-1 && x <= j+1 {
			p2[bi] = '#'
		} else {
			p2[bi] = '.'
		}
		bi++
		j++
		if j == 20 {
			p1 += (i + 1) * x
		}
		if j == 40 {
			p2[bi] = '\n'
			j = 0
			bi++
		}
		x += inc[k]
		k++
		if k == num {
			k = 0
		}
	}
	return p1, p2
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\nPart 2:\n%s", p1, string(p2[:]))
	}
}

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

var benchmark = false
