package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Seat byte

const (
	None Seat = iota
	Occupied
	Empty
	NoneOutside
)

type Seats []Seat

type Map struct {
	cur   Seats
	new   Seats
	w, h  int
	debug bool
}

func NewMap(lines []string) *Map {
	h := len(lines)
	w := len(lines[0])
	m := make(Seats, h*w)
	nm := make(Seats, h*w)
	for y, line := range lines {
		for x, s := range line {
			if s == 'L' {
				m[y*w+x] = Empty
			} else if s == '#' {
				m[y*w+x] = Occupied
			} else {
				m[y*w+x] = None
			}
		}
	}
	return &Map{m, nm, w, h, DEBUG()}
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

func (m *Map) Swap() {
	m.cur, m.new = m.new, m.cur
}

func (m *Map) Seat(x, y int) Seat {
	if x >= 0 && x < m.w && y >= 0 && y < m.h {
		return m.cur[y*m.w+x]
	}
	return NoneOutside
}

func (m *Map) Next(cur Seat, x, y int, group int, sight bool) Seat {
	oc := 0
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
		if s == Occupied {
			oc++
		}
	}
	if cur == Empty && oc == 0 {
		return Occupied
	} else if cur == Occupied && oc >= group {
		return Empty
	}
	return cur
}

func (m *Map) Run(group int, sight bool) int {
	for {
		ch := 0
		oc := 0
		for x := 0; x < m.w; x++ {
			for y := 0; y < m.h; y++ {
				cur := m.Seat(x, y)
				if cur == None {
					continue
				}
				newSeat := m.Next(cur, x, y, group, sight)
				if cur != newSeat {
					ch++
				}
				m.SetSeat(x, y, newSeat)
				if newSeat == Occupied {
					oc++
				}
			}
		}
		if m.debug {
			fmt.Printf("%s", m)
			fmt.Printf("changes=%d oc=%d\n", ch, oc)
		}
		if ch == 0 {
			return oc
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
