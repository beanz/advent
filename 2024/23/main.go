package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, string) {
	g := [456976]bool{}
	dedup := map[int]struct{}{}
	nodes := []int{}
	for i := 0; i < len(in); i += 6 {
		a := int(in[i]-'a')*26 + int(in[i+1]-'a')
		b := int(in[i+3]-'a')*26 + int(in[i+4]-'a')
		g[a*26*26+b] = true
		g[b*26*26+a] = true
		if _, ok := dedup[a]; !ok {
			nodes = append(nodes, a)
			dedup[a] = struct{}{}
		}
		if _, ok := dedup[b]; !ok {
			nodes = append(nodes, b)
			dedup[b] = struct{}{}
		}
	}
	hasT := func(a int) bool {
		return a/26 == 't'-'a'
	}
	p1 := 0
	for i := 0; i < len(nodes); i++ {
		a := nodes[i]
		for j := i + 1; j < len(nodes); j++ {
			b := nodes[j]
			for k := j + 1; k < len(nodes); k++ {
				c := nodes[k]
				if g[a*26*26+b] && g[a*26*26+c] && g[b*26*26+c] {
					if hasT(a) || hasT(b) || hasT(c) {
						p1++
					}
				}
			}
		}
	}
	sort.Ints(nodes)
	best := make([]int, 0, 32)
	{
		set := make([]int, 0, 32)
		dedup := [676]bool{}
		for i := 0; i < len(nodes); i++ {
			a := nodes[i]
			if dedup[a] {
				continue
			}
			dedup[a] = true
			set = append(set, a)
			for j := 0; j < len(nodes); j++ {
				if i == j {
					continue
				}
				b := nodes[j]
				if !g[a*26*26+b] {
					continue
				}
				l := 0
				for _, c := range set {
					if g[b*26*26+c] {
						l++
					}
				}
				if l == len(set) {
					dedup[b] = true
					set = append(set, b)
				}
			}
			if len(set) > len(best) {
				best, set = set, best
			}
			set = set[:0]
		}
	}

	p2 := make([]byte, 0, 38)
	p2 = append(p2, byte(best[0]/26+'a'), byte(best[0]%26+'a'))
	for i := 1; i < len(best); i++ {
		p2 = append(p2, ',', byte(best[i]/26+'a'), byte(best[i]%26+'a'))
	}
	return p1, string(p2)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
