package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Map struct {
	l     []string
	n     int
	m     int
	debug bool
}

func (m *Map) String() string {
	s := fmt.Sprintf("%d %d %v", m.n, m.m, m.debug)
	return s
}

func NewMap(lines []string) *Map {
	n := len(lines[0])
	m := len(lines)
	return &Map{lines, n, m, false}
}

func (m *Map) IsTree(x, y int) bool {
	return m.l[y%m.m][x%m.n] == '#'
}

func (m *Map) Calc(sx, sy int) int64 {
	var trees int64
	x, y := 0, 0
	for y < m.m {
		if m.IsTree(x, y) {
			trees++
		}
		if m.debug {
			fmt.Printf("%d,%d %d\n", x, y, trees)
		}
		x += sx
		y += sy
	}
	return trees
}

func (m *Map) Part1() int64 {
	return m.Calc(3, 1)
}

func (m *Map) Part2() int64 {
	var product int64 = 1
	for _, slope := range [][]int{[]int{1, 1}, []int{3, 1}, []int{5, 1},
		[]int{7, 1}, []int{1, 2}} {
		product *= m.Calc(slope[0], slope[1])
	}
	return product
}

func main() {
	lines := InputLines(input)
	m := NewMap(lines)
	//fmt.Printf("%s\n", m)
	p1 := m.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := m.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
