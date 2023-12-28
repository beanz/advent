package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	w := int16(bytes.Index(in, []byte{'\n'}))
	s := int16(bytes.Index(in, []byte{'S'}))
	w1 := int16(w + 1)
	h := int16(len(in)) / w1
	rp := make(map[[2]int16]struct{}, 102400)
	rp[[2]int16{s % w1, s / w1}] = struct{}{}
	np := make(map[[2]int16]struct{}, 102400)
	visit := make(map[[2]int16]struct{}, 102400)
	c1, c2 := 0, 0
	p1 := 0
	chAt1 := func(x, y int16) byte {
		if 0 <= x && x < w && 0 <= y && y < h {
			k := [2]int16{x, y}
			if _, ok := visit[k]; ok {
				return '#'
			}
			visit[k] = struct{}{}
			return in[x+y*w1]
		}
		return '#'
	}

	iter := func(chAtFn func(x, y int16) byte) int {
		for p := range rp {
			x, y := p[0], p[1]
			if chAtFn(x-1, y) != '#' {
				np[[2]int16{x - 1, y}] = struct{}{}
			}
			if chAtFn(x+1, y) != '#' {
				np[[2]int16{x + 1, y}] = struct{}{}
			}
			if chAtFn(x, y-1) != '#' {
				np[[2]int16{x, y - 1}] = struct{}{}
			}
			if chAtFn(x, y+1) != '#' {
				np[[2]int16{x, y + 1}] = struct{}{}
			}
		}

		rp, np = np, rp
		clear(np)
		p1 := c2 + len(rp)
		c1, c2 = p1, c1
		return p1
	}

	for step := 1; step <= 64; step++ {
		p1 = iter(chAt1)
	}
	clear(rp)
	clear(visit)
	c1, c2 = 0, 0
	rp[[2]int16{s % w1, s / w1}] = struct{}{}
	target := 26501365
	mod := target % int(w)
	seen := make([]int, 0, 3)
	chAt := func(x, y int16) byte {
		k := [2]int16{x, y}
		if _, ok := visit[k]; ok {
			return '#'
		}
		visit[k] = struct{}{}
		return in[Mod(x, w)+w1*Mod(y, h)]
	}

	for step := 1; step <= 1000; step++ {
		c := iter(chAt)
		if (step % int(w)) == mod {
			seen = append(seen, c)
			if len(seen) == 3 {
				break
			}
		}
	}

	x := 1 + (target / int(w))
	a := ((seen[2] - seen[1]) - (seen[1] - seen[0])) / 2
	b := (seen[1] - seen[0]) - 3*a
	c := seen[0] - b - a
	p2 := a*x*x + b*x + c
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
