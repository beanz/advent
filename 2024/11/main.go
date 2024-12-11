package main

import (
	_ "embed"
	"fmt"
	"strconv"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type rec struct {
	s, n int
}

func blink(mem map[rec]int, s, n int) int {
	if n == 0 {
		return 1
	}
	if v, ok := mem[rec{s, n}]; ok {
		return v
	}
	var res int
	ss := strconv.Itoa(s)
	l := len(ss)
	switch {
	case s == 0:
		res = blink(mem, 1, n-1)
	case l%2 == 0:
		as, bs := ss[0:len(ss)/2], ss[len(ss)/2:]
		a, _ := strconv.Atoi(as)
		b, _ := strconv.Atoi(bs)
		resA := blink(mem, a, n-1)
		resB := blink(mem, b, n-1)
		res = resA + resB
	default:
		res = blink(mem, s*2024, n-1)
	}
	mem[rec{s, n}] = res
	return res
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	mem := make(map[rec]int, 131072)
	for i := 0; i < len(in); {
		j, s := ChompUInt[int](in, i)
		i = j + 1
		p1 += blink(mem, s, 25)
		p2 += blink(mem, s, 75)
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
