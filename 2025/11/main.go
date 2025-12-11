package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	g := map[int][]int{}
	for i := 0; i < len(in); i++ {
		id := (int(in[i]-'a')*26+int(in[i+1]-'a'))*26 + int(in[i+2]-'a')
		i += 4
		for ; i+3 < len(in) && in[i] != '\n'; i += 3 {
			i++
			o := (int(in[i]-'a')*26+int(in[i+1]-'a'))*26 + int(in[i+2]-'a')
			g[id] = append(g[id], o)
		}
	}
	var search func(cur int) int
	search = func(cur int) int {
		if cur == 10003 {
			return 1
		}
		r := 0
		for _, n := range g[cur] {
			r += search(n)
		}
		return r
	}
	var search2 func(cur [2]int) int
	cache := map[[2]int]int{}
	search2 = func(cur [2]int) int {
		if r, ok := cache[cur]; ok {
			return r
		}
		if cur[0] == 10003 {
			if cur[1] == 3 {
				return 1
			} else {
				return 0
			}
		}
		r := 0
		if cur[0] == 3529 {
			cur[1] |= 2
		}
		if cur[0] == 2030 {
			cur[1] |= 1
		}
		for _, n := range g[cur[0]] {
			r += search2([2]int{n, cur[1]})
		}
		cache[cur] = r
		return r
	}
	return search(16608), search2([2]int{12731, 0})
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
