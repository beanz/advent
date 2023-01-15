package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int int32

func Parts(in []byte) (Int, Int) {
	var p1 Int
	acc := make([]Int, 0, 1024)
	for i := 0; i < len(in); {
		j, n := ChompInt[Int](in, i)
		p1 += n
		acc = append(acc, p1)
		i = j + 1
	}
	ri, rq := -1, Int(99999999)
	for i := range acc {
		for j := i + 1; j < len(acc); j++ {
			d := Abs(acc[i] - acc[j])
			if d%p1 == 0 {
				q := d / p1
				if q < rq {
					ri, rq = MaxInt(i, j), q
				}
			}
		}
	}
	return p1, acc[ri]
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
