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
	m *ByteMap
}

func NewLavaTubes(in []byte) *LavaTubes {
	return &LavaTubes{NewByteMap(in)}
}

func (l *LavaTubes) String() string {
	return l.m.String()
}

func (l *LavaTubes) Calc() (int, int) {
	risk := 0
	sizes := make([]int, 0, 512)
	stack := make([]int, 0, 512)
	for ch := byte('0'); ch < '9'; ch++ {
		l.m.Visit(func(li int, v byte) (byte, bool) {
			if v != ch {
				return 0, false
			}
			risk += int(v-byte('0')) + 1
			size := 0
			todo := stack[:0]
			todo = append(todo, li)
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
			return 0, false
		})
	}
	sort.Ints(sizes)
	p2 := sizes[len(sizes)-3] * sizes[len(sizes)-2] * sizes[len(sizes)-1]
	return risk, p2
}

func main() {
	inp := InputBytes(input)
	g := NewLavaTubes(inp)
	p1, p2 := g.Calc()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	} else {
		if p1 != 456 {
			panic(fmt.Sprintf("benchmark got wrong result %d should be %d",
				p1, 456))
		}
		if p2 != 1047744 {
			panic(fmt.Sprintf("benchmark got wrong result %d should be %d",
				p1, 1047744))
		}
	}
}

var benchmark = false
