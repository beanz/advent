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
	g := [1048576]bool{}
	dedup := [1024]bool{}
	nodes := make([]int, 0, 1024)
	for i := 0; i < len(in); i += 6 {
		a := (int(in[i]-'a') << 5) + int(in[i+1]-'a')
		b := (int(in[i+3]-'a') << 5) + int(in[i+4]-'a')
		g[(a<<10)+b] = true
		g[(b<<10)+a] = true
		if !dedup[a] {
			nodes = append(nodes, a)
			dedup[a] = true
		}
		if !dedup[b] {
			nodes = append(nodes, b)
			dedup[b] = true
		}
	}
	hasT := func(a int) bool {
		return (a >> 5) == 't'-'a'
	}
	p1 := 0
	for i := 0; i < len(nodes); i++ {
		a := nodes[i]
		ai := a << 10
		for j := i + 1; j < len(nodes); j++ {
			b := nodes[j]
			bi := b << 10
			for k := j + 1; k < len(nodes); k++ {
				c := nodes[k]
				if g[ai+b] && g[ai+c] && g[bi+c] {
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
		dedup := [1024]bool{}
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
				if !g[(a<<10)+b] {
					continue
				}
				l := 0
				for _, c := range set {
					if g[(b<<10)+c] {
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
	p2 = append(p2, byte((best[0]>>5)+'a'), byte((best[0]&0x1f)+'a'))
	for i := 1; i < len(best); i++ {
		p2 = append(p2, ',', byte((best[i]>>5)+'a'), byte((best[i]&0x1f)+'a'))
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
