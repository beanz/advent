package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type LavaTubes struct {
	m    *ByteMap
	lows []int
}

func NewLavaTubes(in []byte) *LavaTubes {
	return &LavaTubes{NewByteMap(in), []int{}}
}

func (l *LavaTubes) String() string {
	return l.m.String()
}

func (l *LavaTubes) Part1() int {
	risk := 0
	l.m.Visit(func(i int, v byte) (byte, bool) {
		for _, nb := range l.m.Neighbours(i) {
			if l.m.Get(nb) <= v {
				return 0, false
			}
		}
		l.lows = append(l.lows, i)
		risk += int(v-byte('0')) + 1
		return 0, false
	})
	return risk
}

func (l *LavaTubes) Part2() int {
	sizes := make([]int, 0, len(l.lows))
	for _, li := range l.lows {
		size := 0
		todo := []int{li}
		for len(todo) > 0 {
			i := todo[0]
			todo = todo[1:]
			if l.m.Get(i) >= '9' {
				continue
			}
			l.m.Set(i, '9')
			size++
			for _, nb := range l.m.Neighbours(i) {
				todo = append(todo, nb)
			}
		}
		sizes = append(sizes, size)
	}
	sort.Ints(sizes)
	return sizes[len(sizes)-3] * sizes[len(sizes)-2] * sizes[len(sizes)-1]
}

func main() {
	inp := InputBytes(input)
	g := NewLavaTubes(inp)
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	} else {
		if p1 != 456 {
			panic(fmt.Sprintf("benchmark got wrong result %d should be %d",
				p1, 456))
		}
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	} else {
		if p2 != 1047744 {
			panic(fmt.Sprintf("benchmark got wrong result %d should be %d",
				p1, 1047744))
		}
	}
}

var benchmark = false
