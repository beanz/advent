package main

import (
	_ "embed"
	"fmt"
	"strings"

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
		o.m.Visit(func(p int, v byte) {
			o.m.Add(p, 1)
		})
		o.m.Visit(func(p int, v byte) {
			if v > '9' && v != '~' {
				o.Flash(p)
			}
		})
		p2 := 0
		o.m.Visit(func(p int, v byte) {
			if v == '~' {
				o.m.Set(p, '0')
				c++
				p2++
			}
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
	}
}

type ByteMap struct {
	d    []byte
	w, h int
}

func NewByteMap(in []byte) (i *ByteMap) {
	var w int
	for i, ch := range in {
		if ch == '\n' {
			w = i + 1 // +1 since we are keeping the newlines
			break
		}
	}
	h := len(in) / w
	return &ByteMap{in, w, h}
}

func (m *ByteMap) String() string {
	var sb strings.Builder
	for y := 0; y < m.h; y++ {
		sb.WriteString(string(m.d[y*m.w : (1+y)*m.w]))
	}
	sb.WriteString(fmt.Sprintf("%d x %d\n", m.w, m.h))
	return sb.String()
}

func (m *ByteMap) Size() int {
	return (m.w - 1) * m.h
}

func (m *ByteMap) IndexToXY(i int) (int, int) {
	x := i % m.w
	return x, (i - x) / m.w
}

func (m *ByteMap) Contains(i int) bool {
	return i >= 0 && (i%m.w) < m.w-1 && i/m.w < m.h
}

func (m *ByteMap) Get(i int) byte {
	return m.d[i]
}

func (m *ByteMap) Set(i int, v byte) {
	m.d[i] = v
}

func (m *ByteMap) Add(i int, v byte) {
	m.d[i] += v
}

func (m *ByteMap) Neighbours(i int) []int {
	x, y := m.IndexToXY(i)
	res := make([]int, 0, 4)
	if x > 0 {
		res = append(res, i-1)
	}
	if x < m.w-2 { // because we've still got newlines!
		res = append(res, i+1)
	}
	if y > 0 {
		res = append(res, i-m.w)
	}
	if y < m.h-1 {
		res = append(res, i+m.w)
	}
	return res
}

func (m *ByteMap) Neighbours8(i int) []int {
	res := make([]int, 0, 8)
	for oy := -1; oy <= 1; oy++ {
		for ox := -1; ox <= 1; ox++ {
			ni := i + ox + oy*m.w
			if m.Contains(ni) {
				res = append(res, ni)
			}
		}
	}
	return res
}

func (m *ByteMap) Visit(fn func(i int, v byte)) {
	for y := 0; y < m.h; y++ {
		for x := 0; x < m.w-1; x++ { // -1 due to newlines
			i := x + y*m.w
			fn(i, m.d[i])
		}
	}
}

var benchmark = false
