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
		inc[j] = 0
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
	sig := [240]int{}
	x := 1
	for i = 0; i < 240; i++ {
		sig[i] = x
		x += inc[i%num]
	}
	p1 := 20*sig[20-1] + 60*sig[60-1] + 100*sig[100-1] + 140*sig[140-1] + 180*sig[180-1] + 220*sig[220-1]
	p2 := [246]byte{}
	j = 0
	for k := 0; k < 240; k++ {
		v := sig[k]
		c := k % 40
		if v >= c-1 && v <= c+1 {
			p2[j] = '#'
		} else {
			p2[j] = '.'
		}
		j++
		if c == 39 {
			p2[j] = '\n'
			j++
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
