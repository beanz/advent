package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func uintLen[T AoCInt](n T) int {
	for l, m := 1, T(10); true; l, m = l+1, m*10 {
		if n < m {
			return l
		}
	}
	panic("unreachable")
}

func blink(mem []int, s, n int) int {
	if n == 0 {
		return 1
	}
	k := (s << 7) + n
	if k < len(mem) {
		if v := mem[k]; v != 0 {
			return v - 1
		}
	}

	var res int
	if s == 0 {
		res = blink(mem, 1, n-1)
	} else if l := uintLen(s); l%2 == 0 {
		var a, b, m, i int
		for a, b, m, i = 0, s, 1, 0; i < l/2; a, b, m, i = a+m*(b%10), b/10, m*10, i+1 {
		}
		resA := blink(mem, a, n-1)
		resB := blink(mem, b, n-1)
		res = resA + resB
	} else {
		res = blink(mem, s*2024, n-1)
	}
	if k < len(mem) {
		mem[k] = res + 1
	}
	return res
}

const CACHE_SIZE = 131072

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	mem := [CACHE_SIZE]int{}
	for i := 0; i < len(in); {
		j, s := ChompUInt[int](in, i)
		i = j + 1
		p1 += blink(mem[:], s, 25)
		p2 += blink(mem[:], s, 75)
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
