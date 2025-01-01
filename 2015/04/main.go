package main

import (
	"crypto/md5"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	var p1 int
	if in[len(in)-1] == '\n' {
		in = in[:len(in)-1]
	}
	n := NewNumStrFromBytes(in)
	for i := 1; ; i++ {
		n.Inc()
		cs := md5.Sum(n.Bytes())
		if cs[0] == 0 && cs[1] == 0 && cs[2]&0xf0 == 0 {
			if p1 == 0 {
				p1 = i
			}
			if cs[2] == 0 {
				return p1, i
			}
		}
	}
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
