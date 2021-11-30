package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

type Seat byte

const (
	None Seat = iota
	Occupied
	Empty
	NoneOutside
)

type Seats []Seat

type Neighbours []int

type Map struct {
	cur    Seats
	new    Seats
	index  []int
	cache1 map[int]Neighbours
	cache2 map[int]Neighbours
	w, h   int
	debug  bool
}

func NewMap(lines []string) *Map {
	h := len(lines)
	w := len(lines[0])
	cur := make(Seats, h*w)
	new := make(Seats, h*w)
	index := make([]int, 0, h*w)
	for y, line := range lines {
		for x, s := range line {
			i := y*w + x
			if s == 'L' {
				cur[i] = Empty
			} else if s == '#' {
				cur[i] = Occupied
			} else {
				cur[i] = None
				continue
			}
			index = append(index, i)
		}
	}
	cache1 := make(map[int]Neighbours, len(index))
	cache2 := make(map[int]Neighbours, len(index))
	m := &Map{cur, new, index, cache1, cache2, w, h, DEBUG()}
	for _, i := range m.index {
		x := i % w
		y := i / w
		cache1[i] = m.Neighbours(x, y, false)
		cache2[i] = m.Neighbours(x, y, true)
	}
	return m
}

func (m *Map) String() string {
	s := ""
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

func (m *Map) SetSeat(x, y int, state Seat) {
	m.new[y*m.w+x] = state
}

func (m *Map) SetSeatByIndex(i int, state Seat) {
	m.new[i] = state
}

func (m *Map) Swap() {
	m.cur, m.new = m.new, m.cur
}

func (m *Map) Seat(x, y int) Seat {
	if x >= 0 && x < m.w && y >= 0 && y < m.h {
		return m.cur[y*m.w+x]
	}
	return NoneOutside
}

func (m *Map) SeatByIndex(i int) Seat {
	return m.cur[i]
}

func (m *Map) Neighbours(x, y int, sight bool) Neighbours {
	n := make(Neighbours, 0, 8)
	for _, o := range EightNeighbourOffsets {
		ox, oy := x, y
		s := None
		for {
			ox, oy = ox+o.X, oy+o.Y
			s = m.Seat(ox, oy)
			if s == NoneOutside || s != None || !sight {
				break
			}
		}
		if s == Empty || s == Occupied {
			n = append(n, ox+m.w*oy)
		}
	}
	return n
}

func (m *Map) OccupiedCount(i int, sight bool) int {
	oc := 0
	var cache map[int]Neighbours
	if sight {
		cache = m.cache2
	} else {
		cache = m.cache1
	}
	for _, i := range cache[i] {
		s := m.SeatByIndex(i)
		if s == Occupied {
			oc++
		}
	}
	return oc
}

func (m *Map) Run(group int, sight bool) int {
	for {
		ch := 0
		c := 0
		for _, i := range m.index {
			cur := m.SeatByIndex(i)
			oc := m.OccupiedCount(i, sight)
			newSeat := cur
			if cur == Empty && oc == 0 {
				newSeat = Occupied
			} else if cur == Occupied && oc >= group {
				newSeat = Empty
			}
			if cur != newSeat {
				ch++
			}
			m.SetSeatByIndex(i, newSeat)
			if newSeat == Occupied {
				c++
			}
		}
		if m.debug {
			fmt.Printf("%s", m)
			fmt.Printf("changes=%d oc=%d\n", ch, c)
		}
		if ch == 0 {
			return c
		}
		m.Swap()
	}
}

func (m *Map) Part1() int {
	return m.Run(4, false)
}

func (m *Map) Part2() int {
	return m.Run(5, true)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewMap(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewMap(lines).Part2())
}
