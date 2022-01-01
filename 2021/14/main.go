package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func pairInt(a, b byte) uint {
	return (uint(a-'A') << 5) + uint(b-'A')
}

type Polymer struct {
	init string
	m    map[uint]byte
}

func NewPolymer(in []byte) *Polymer {
	i := 0
	var p *Polymer
	for ; i < len(in); i++ {
		if in[i] == '\n' {
			p = &Polymer{string(in[0:i]), make(map[uint]byte, 128)}
			break
		}
	}
	i += 2
	for ; i < len(in); i += 8 {
		p.m[pairInt(in[i], in[i+1])] = in[i+6]
	}
	return p
}

func (p *Polymer) MostMinusLeast(pc map[uint]int) int {
	chCount := NewSliceByteCounter(26)
	chCount.Inc(p.init[len(p.init)-1])
	for pair, c := range pc {
		a := byte('A'+(pair>>5))
		chCount.Add(a, c)
	}
	min := chCount.Count(chCount.Bottom(1)[0])
	max := chCount.Count(chCount.Top(1)[0])
	return max - min
}

func (p *Polymer) Parts() (int, int) {
	pairCount := make(map[uint]int, 100)
	for i := 0; i < len(p.init)-1; i++ {
		pairCount[pairInt(p.init[i], p.init[i+1])]++
	}
	p1 := 0
	for day := 1; day <= 40; day++ {
		npc := make(map[uint]int, 100)
		for pair, c := range pairCount {
			a, b := byte('A'+(pair>>5)), byte('A'+(pair%32))
			n := p.m[pair]
			npc[pairInt(a, n)] += c
			npc[pairInt(n, b)] += c
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
