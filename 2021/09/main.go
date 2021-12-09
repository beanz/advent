package main

import (
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

type LavaTubes struct {
	m    *IntMap
	lows []int
}

func NewLavaTubes(in []string) *LavaTubes {
	return &LavaTubes{NewIntMap(in), []int{}}
}

func (l *LavaTubes) Part1() int {
	risk := 0
	l.m.Visit(func(i, v int) {
		for _, nb := range l.m.Neighbours(i) {
			if l.m.Get(nb) <= v {
				return
			}
		}
		l.lows = append(l.lows, i)
		risk += v + 1
	})
	return risk
}

func (l *LavaTubes) Part2() int {
	sizes := make([]int, 0, len(l.lows))
	for _, li := range l.lows {
		visited := make(map[int]bool, 100)
		size := 0
		todo := []int{li}
		for len(todo) > 0 {
			i := todo[0]
			todo = todo[1:]
			if _, ok := visited[i]; ok {
				continue
			}
			visited[i] = true
			size++
			for _, nb := range l.m.Neighbours(i) {
				if l.m.Get(nb) < 9 {
					todo = append(todo, nb)
				}
			}
		}
		sizes = append(sizes, size)
	}
	sort.Ints(sizes)
	return sizes[len(sizes)-3] * sizes[len(sizes)-2] * sizes[len(sizes)-1]
}

func main() {
	inp := ReadInputLines()
	g := NewLavaTubes(inp)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}

type IntMap struct {
	d    []int
	w, h int
}

func NewIntMap(in []string) (i *IntMap) {
	h := len(in)
	w := len(in[0])
	m := IntMap{make([]int, 0, h*w), w, h}
	for _, l := range in {
		for _, ch := range l {
			m.d = append(m.d, int(byte(ch)-byte('0')))
		}
	}
	return &m
}

func (m *IntMap) IndexToXY(i int) (int, int) {
	x := i % m.w
	return x, (i - x) / m.w
}

func (m *IntMap) Contains(i int) bool {
	x, y := m.IndexToXY(i)
	return x >= 0 && x < m.w && y >= 0 && y < m.h
}

func (m *IntMap) Get(i int) int {
	return m.d[i]
}

func (m *IntMap) Neighbours(i int) []int {
	x, y := m.IndexToXY(i)
	res := make([]int, 0, 4)
	if x > 0 {
		res = append(res, i-1)
	}
	if x < m.w-1 {
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

func (m *IntMap) Visit(fn func(i, v int)) {
	for i := 0; i < m.w*m.h; i++ {
		fn(i, m.d[i])
	}
}
