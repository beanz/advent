package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Decompress(in []byte) int {
	l := 0;
	for i := 0; i < len(in); i++ {
		if in[i] == '(' {
			n, j := ScanUint(in, i+1)
			i = j+1 // skip 'x'
			t, j := ScanUint(in, i)
			i = j
			i++ // skip ')'
			sl := n*t
			l += sl
			i += n-1
		} else {
			l++
		}
	}
	return l
}

func DecompressV2(in []byte) int {
	l := 0
	for i := 0; i < len(in); i++ {
		if in[i] == '(' {
			n, j := ScanUint(in, i+1)
			i = j+1 // skip 'x'
			t, j := ScanUint(in, i)
			i = j
			i++ // skip ')'
			sl := DecompressV2(in[i:i+n])
			sl *= t
			l += sl
			i += n-1
		} else {
			l++
		}
	}
	return l
}

func main() {
	inp := InputBytes(input)
	inp = inp[:len(inp)-1] // remove '\n' first
	p1 := Decompress(inp)
	p2 := DecompressV2(inp)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
