package main

import (
	"fmt"
	"math"
	"strings"

	. "github.com/beanz/advent2015/lib"
)

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
	orig := []int{}
	for i := 0; i < len(t.p); i++ {
		orig = append(orig, i)
	}
	for perm := make([]int, len(orig)); perm[0] < len(perm); nextPerm(perm) {
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
	s := ReadInputLines()
	t := NewTable(s)
	fmt.Printf("Part 1: %d\n", t.Part1())
	fmt.Printf("Part 2: %d\n", t.Part2())
}

func nextPerm(p []int) {
	for i := len(p) - 1; i >= 0; i-- {
		if i == 0 || p[i] < len(p)-i-1 {
			p[i]++
			return
		}
		p[i] = 0
	}
}