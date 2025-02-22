package main

import (
	_ "embed"
	"fmt"
	"strconv"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Iter(s string) string {
	return Run(s, 1)
}

func Run(s string, num int) string {
	cur := make([]byte, 0, 104000*num)
	cur = append(cur, s...)
	next := make([]byte, 0, 104000*num)
	for j := 0; j < num; j++ {
		n := int64(1)
		c := cur[0]
		for i := 1; i < len(cur); i++ {
			if cur[i] == c {
				n++
			} else {
				next = strconv.AppendInt(next, n, 10)
				next = append(next, c)
				c = cur[i]
				n = 1
			}
		}
		next = strconv.AppendInt(next, n, 10)
		next = append(next, c)
		cur, next = next, cur
		next = next[:0]
	}
	return string(cur)
}

func main() {
	in := InputLines(input)
	s40 := Run(in[0], 40)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", len(s40))
	}
	s50 := Run(s40, 10)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", len(s50))
	}
}

var benchmark bool
