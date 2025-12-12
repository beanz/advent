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
	var search func(cur, end int) int
	cache := make(map[int]int, 600)
	search = func(cur, end int) int {
		if r, ok := cache[cur]; ok {
			return r
		}
		if cur == end {
			return 1
		}
		r := 0
		for _, n := range g[cur] {
			r += search(n, end)
		}
		cache[cur] = r
		return r
	}
	p2a := search(12731, 3529)
	for k := range cache {
		delete(cache, k)
	}
	p2b := search(3529, 2030)
	for k := range cache {
		delete(cache, k)
	}
	p2c := search(2030, 10003)
	for k := range cache {
		delete(cache, k)
	}
	return search(16608, 10003), p2a * p2b * p2c
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
