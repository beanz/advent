package main

import (
	_ "embed"
	"fmt"
	"sort"
	"strings"

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
	N := func(a int) string {
		return string([]byte{byte(a/26) + 'a', byte(a%26) + 'a'})
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
	c := [][]int{}
	bronKerbosch(nil, nodes, nil, g[:], &c)
	p2 := ""
	for _, clique := range c {
		n := []string{}
		for _, e := range clique {
			n = append(n, N(e))
		}
		sort.Strings(n)
		r := strings.Join(n, ",")
		if len(r) > len(p2) {
			p2 = r
		}
	}

	return p1, p2
}

func bronKerbosch(r []int, p []int, x []int, g []bool, c *[][]int) {
	if len(p) == 0 && len(x) == 0 {
		*c = append(*c, r)
		return
	}
	for len(p) > 0 {
		n := p[0]
		p = p[1:]
		nr := append([]int{n}, r...)
		var np []int
		for _, nn := range p {
			if g[n*26*26+nn] {
				np = append(np, nn)
			}
		}
		var nx []int
		for _, nn := range x {
			if g[n*26*26+nn] {
				nx = append(nx, nn)
			}
		}
		bronKerbosch(nr, np, nx, g, c)
		x = append(x, n)
	}
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
