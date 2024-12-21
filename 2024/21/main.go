package main

import (
	_ "embed"
	"fmt"

	keypads "github.com/beanz/advent/2024/21/pkg"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

//go:generate go run gen/main.go

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	i := 0
	for i < len(in) {
		j, n := ChompUInt[int](in, i)
		var l1, l2 int
		if n < 1000 {
			l1 = depth2[n]
			l2 = depth25[n]
		} else {
			l1 = keypads.MoveLen(string(in[i:j+1]), 2)
			l2 = keypads.MoveLen(string(in[i:j+1]), 25)
		}
		p1 += n * l1
		p2 += n * l2
		i = j + 2
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
