package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Pair struct {
	a, b byte
}

type Polymer struct {
	init string
	m    map[Pair]byte
}

func NewPolymer(in []byte) *Polymer {
	i := 0
	var p *Polymer
	for ; i < len(in); i++ {
		if in[i] == '\n' {
			p = &Polymer{string(in[0:i]), make(map[Pair]byte, 128)}
			break
		}
	}
	i += 2
	for ; i < len(in); i += 8 {
		p.m[Pair{in[i], in[i+1]}] = in[i+6]
	}
	return p
}

func (p *Polymer) MostMinusLeast(pc map[Pair]int) int {
	chCount := NewMapByteCounter(26)
	chCount.Inc(p.init[len(p.init)-1])
	for pair, c := range pc {
		chCount.Add(pair.a, c)
	}
	min := chCount.Count(chCount.Bottom(1)[0])
	max := chCount.Count(chCount.Top(1)[0])
	return max - min
}

func (p *Polymer) Parts() (int, int) {
	pairCount := make(map[Pair]int, 100)
	for i := 0; i < len(p.init)-1; i++ {
		pairCount[Pair{p.init[i], p.init[i+1]}]++
	}
	p1 := 0
	for day := 1; day <= 40; day++ {
		npc := make(map[Pair]int, 100)
		for pair, c := range pairCount {
			n := p.m[pair]
			npc[Pair{pair.a, n}] += c
			npc[Pair{n, pair.b}] += c
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
