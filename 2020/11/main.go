package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Seat byte

const (
	Empty Seat = iota
	Occupied
	None
	NoneOutside
)

type Seats map[Point]Seat

type Map struct {
	m     Seats
	w, h  int
	debug bool
}

func NewMap(lines []string) *Map {
	h := len(lines)
	w := len(lines[0])
	mm := make(Seats, h*w)
	for y, line := range lines {
		for x, s := range line {
			if s == 'L' {
				mm[Point{x, y}] = Empty
			}
		}
	}
	m := &Map{mm, w, h, false}
	return m
}

func (m *Map) String() string {
	s := fmt.Sprintf("%d x %d\n", m.w, m.h)
	for y := 0; y < m.h; y++ {
		for x := 0; x < m.w; x++ {
			if m.Seat(x, y) == Empty {
				s += "L"
			} else if m.Seat(x, y) == Occupied {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func (m *Map) Seat(x, y int) Seat {
	if x < 0 || x > m.w-1 || y < 0 || y > m.h-1 {
		return NoneOutside
	}
	if v, ok := m.m[Point{x, y}]; ok {
		return v
	}
	return None
}

func Next1(m *Map, x, y int) Seat {
	n := m.Seat(x, y)
	if n == None {
		return None
	}
	neighbourOffsets := Point{x, y}.Neighbours8()
	c := make(map[Seat]int, 4)
	for _, n := range neighbourOffsets {
		s := m.Seat(n.X, n.Y)
		c[s]++
	}
	if n == Empty && c[Occupied] == 0 {
		n = Occupied
	} else if n == Occupied && c[Occupied] >= 4 {
		n = Empty
	}
	return n
}

func Next2(m *Map, x, y int) Seat {
	n := m.Seat(x, y)
	if n == None {
		return None
	}
	neighbourOffsets := Point{0, 0}.Neighbours8()
	c := make(map[Seat]int, 4)
	for _, o := range neighbourOffsets {
		ox, oy := x, y
		s := None
		for {
			ox, oy = ox+o.X, oy+o.Y
			s = m.Seat(ox, oy)
			if s == NoneOutside {
				s = None
				break
			} else if s != None {
				break
			}
		}
		c[s]++
	}
	if n == Empty && c[Occupied] == 0 {
		n = Occupied
	} else if n == Occupied && c[Occupied] >= 5 {
		n = Empty
	}
	return n
}

func (m *Map) Run(fn func(*Map, int, int) Seat) int {
	seen := make(map[int]bool)
	for {
		if m.debug {
			fmt.Printf("%s", m)
		}
		nm := make(Seats, len(m.m))
		oc := 0
		for x := 0; x < m.w; x++ {
			for y := 0; y < m.h; y++ {
				newSeat := fn(m, x, y)
				if newSeat != None {
					nm[Point{x, y}] = newSeat
				}
				if newSeat == Occupied {
					oc++
				}
			}
		}
		if _, ok := seen[oc]; ok {
			return oc
		}
		seen[oc] = true
		m.m = nm
	}
	return 1
}

func (m *Map) Part1() int {
	return m.Run(Next1)
}

func (m *Map) Part2() int {
	return m.Run(Next2)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewMap(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewMap(lines).Part2())
}
