package main

import (
	_ "embed"
	"fmt"
	"math"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Table struct {
	h map[int]int
	p []byte
}

func NewTable(in []string) *Table {
	h := make(map[int]int, 2*len(in))
	p := []byte{}
	seen := make(map[byte]bool, 10)
	for _, l := range in {
		s := strings.Split(l, " ")
		p1, p2, n := s[0][0], s[10][0], MustParseInt(s[3])
		if s[2] == "lose" {
			n *= -1
		}
		h[int(p1)+256*int(p2)] = n
		if seen[p1] {
			continue
		}
		seen[p1] = true
		p = append(p, p1)
	}
	return &Table{h, p}
}

func (t *Table) Calc() int {
	max := math.MinInt32
	p := NewPerms(len(t.p))
	for perm := p.Get(); !p.Done(); perm = p.Next() {
		s := 0
		for i := 0; i < len(perm); i++ {
			p1, p2 := t.p[perm[i]], t.p[perm[(i+1)%len(perm)]]
			s += t.h[int(p1)+256*int(p2)]
			s += t.h[int(p2)+256*int(p1)]
		}
		if s > max {
			max = s
		}
	}
	return max
}

func (t *Table) Part1() int {
	return t.Calc()
}

func (t *Table) Part2() int {
	t.p = append(t.p, '!')
	return t.Calc()
}

func main() {
	s := InputLines(input)
	t := NewTable(s)
	p1 := t.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := t.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
