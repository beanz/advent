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

type LavaTubes struct {
	m    *ByteMap
	lows []int
}

func NewLavaTubes(in []byte) *LavaTubes {
	return &LavaTubes{NewByteMap(in), []int{}}
}

func (l *LavaTubes) Part1() int {
	risk := 0
	l.m.Visit(func(i int, v byte) {
		for _, nb := range l.m.Neighbours(i) {
			if l.m.Get(nb) <= v {
				return
			}
		}
		l.lows = append(l.lows, i)
		risk += int(v-byte('0')) + 1
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
	bytes := InputBytes(input)
	var inp []byte
	inp = make([]byte, len(input))
	copy(inp, bytes)
	g := NewLavaTubes(inp)
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
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

func (m *ByteMap) Visit(fn func(i int, v byte)) {
	for y := 0; y < m.h; y++ {
		for x := 0; x < m.w-1; x++ { // -1 due to newlines
			i := x + y*m.w
			fn(i, m.d[i])
		}
	}
}

var benchmark = false
