package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	p1, p2 := 0, 0
	for i := 0; i < len(in); i++ {
		l := make([]int, 0, 21)
		var n int
		for ; ; i++ {
			i, n = ChompInt[int](in, i)
			l = append(l, n)
			if in[i] == '\n' {
				break
			}
		}
		l2 := make([]int, len(l))
		for j, k := 0, len(l)-1; j < len(l); j, k = j+1, k-1 {
			l2[k] = l[j]
		}
		s := Solve(l)
		p1 += s
		p2 += Solve(l2)
	}
	return p1, p2
}

func Solve(l []int) int {
	f := l[len(l)-1]
	for {
		done := true
		for i := 0; i < len(l)-1; i++ {
			d := l[i+1] - l[i]
			if d != 0 {
				done = false
			}
			l[i] = d
		}
		if done {
			return f
		}
		l = l[:len(l)-1]
		f += l[len(l)-1]
	}
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
