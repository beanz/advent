package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int int32

func Parts(in []byte, args ...int) (int, int) {
	ids := make(map[int]Int, 600)
	g := map[Int][]Int{}
	readID := func(i int) Int {
		n := (int(in[i]-'a')*26+int(in[i+1]-'a'))*26 + int(in[i+2]-'a')
		if id, ok := ids[n]; ok {
			return id
		}
		ids[n] = Int(len(ids))
		return ids[n]
	}
	for i := 0; i < len(in); i++ {
		id := readID(i)
		i += 4
		for ; i+3 < len(in) && in[i] != '\n'; i += 3 {
			i++
			o := readID(i)
			g[id] = append(g[id], o)
		}
	}
	var mx int
	var search func(cur, end Int) int
	cache := [600]int{}
	cacheOffset := 1
	search = func(cur, end Int) int {
		if r := cache[cur]; r >= cacheOffset {
			return r - cacheOffset
		}
		if cur == end {
			return 1
		}
		r := 0
		for _, n := range g[cur] {
			r += search(n, end)
		}
		cache[cur] = r + cacheOffset
		mx = max(r, mx)
		return r
	}
	out := ids[10003]
	var p1, p2 int
	you, p1Ok := ids[16608]
	if p1Ok {
		p1 = search(you, out)
		cacheOffset += 10000000
	}
	svr, p2Ok := ids[12731]
	if p2Ok {
		fft := ids[3529]
		dac := ids[2030]
		p2a := search(svr, fft)
		cacheOffset += 10000000
		p2b := search(fft, dac)
		cacheOffset += 10000000
		p2c := search(dac, out)
		p2 = p2a * p2b * p2c
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
