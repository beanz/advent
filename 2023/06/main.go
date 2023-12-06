package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	t := 0
	ts := make([]int, 0, 4)
	i := 0
	n := 0
	num := false
	for ; in[i] != '\n'; i++ {
		switch in[i] {
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			num = true
			d := int(in[i] - '0')
			n = n*10 + d
			t = t*10 + d
		default:
			if num {
				ts = append(ts, n)
			}
			num = false
			n = 0
		}
	}
	if num {
		ts = append(ts, n)
	}
	num = false
	n = 0
	r := 0
	rs := make([]int, 0, 4)
	for i++; in[i] != '\n'; i++ {
		switch in[i] {
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			num = true
			d := int(in[i] - '0')
			n = n*10 + d
			r = r*10 + d
		default:
			if num {
				rs = append(rs, n)
			}
			num = false
			n = 0
		}
	}
	if num {
		rs = append(rs, n)
	}
	p1 := 1
	for i := 0; i < len(ts); i++ {
		c := race(ts[i], rs[i])
		if c > 0 {
			p1 *= c
		}
	}
	return p1, race(t, r)
}

func race(t, r int) int {
	c := 0
	for h := 1; h < t; h++ {
		d := (t - h) * h
		if d > r {
			c++
		}
	}
	return c
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
