package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	m := NewMap(lines)
	//fmt.Printf("%s\n", m)
	fmt.Printf("Part 1: %d\n", m.Part1())
	fmt.Printf("Part 2: %d\n", m.Part2())
}
