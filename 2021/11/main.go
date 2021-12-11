package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Octopodes struct {
	m *ByteMap
}

func NewOctopodes(in []byte) *Octopodes {
	return &Octopodes{NewByteMap(in)}
}

func (o Octopodes) String() string {
	return o.m.String()
}

func (o *Octopodes) Flash(p int) {
	o.m.Set(p, '~')
	n8 := o.m.Neighbours8(p)
	for _, nb := range n8 {
		v := o.m.Get(nb)
		if v == '~' {
			continue
		}
		o.m.Set(nb, v+1)
		if v >= '9' {
			o.Flash(nb)
		}
	}
}

func (o *Octopodes) Calc(days int) (int, int) {
	c := 0
	day := 1
	p1 := -1
	for {
		o.m.Visit(func(p int, v byte) (byte, bool) {
			return v + 1, true
		})
		o.m.Visit(func(p int, v byte) (byte, bool) {
			if v > '9' && v != '~' {
				o.Flash(p)
			}
			return 0, false
		})
		p2 := 0
		o.m.Visit(func(p int, v byte) (byte, bool) {
			if v != '~' {
				return 0, false
			}
			c++
			p2++
			return '0', true
		})
		if day == days {
			p1 = c
		}
		if p2 == o.m.Size() {
			return p1, day
		}
		day++
	}
	return p1, -1
}

func main() {
	bytes := InputBytes(input)
	var inp []byte
	inp = make([]byte, len(bytes))
	copy(inp, bytes)
	g := NewOctopodes(inp)
	p1, p2 := g.Calc(100)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	} else {
		if p1 != 1652 {
			panic(fmt.Sprintf("benchmark got wrong result %d should be %d",
				p1, 1652))
		}
		if p2 != 220 {
			panic(fmt.Sprintf("benchmark got wrong result %d should be %d",
				p1, 220))
		}
	}
}

var benchmark = false
