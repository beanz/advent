package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Polymer struct {
	init string
	m    map[string]string
}

func NewPolymer(in []byte) *Polymer {
	i := 0
	var p *Polymer
	for ; i < len(in); i++ {
		if in[i] == '\n' {
			p = &Polymer{string(in[0:i]), make(map[string]string, 128)}
			break
		}
	}
	i += 2
	for ; i < len(in); i += 8 {
		p.m[string(in[i:i+2])] = string(in[i+6])
	}
	return p
}

func (p *Polymer) MostMinusLeast(pc map[string]int) int {
	chCount := NewSliceByteCounter(26)
	chCount.Inc(p.init[len(p.init)-1])
	for pair, c := range pc {
		chCount.Add(pair[0], c)
	}
	min := chCount.Count(chCount.Bottom(1)[0])
	max := chCount.Count(chCount.Top(1)[0])
	return max - min
}

func (p *Polymer) Parts() (int, int) {
	pairCount := make(map[string]int, 100)
	for i := 0; i < len(p.init)-1; i++ {
		pairCount[p.init[i:i+2]]++
	}
	p1 := 0
	for day := 1; day <= 40; day++ {
		npc := make(map[string]int, 100)
		for pair, c := range pairCount {
			n := p.m[pair]
			npc[string(pair[0])+string(n)] += c
			npc[string(n)+string(pair[1])] += c
		}
		pairCount = npc
		if day == 10 {
			p1 = p.MostMinusLeast(pairCount)
		}
	}
	return p1, p.MostMinusLeast(pairCount)
}

func main() {
	g := NewPolymer(InputBytes(input))
	p1, p2 := g.Parts()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
