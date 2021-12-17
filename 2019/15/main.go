package main

import (
	_ "embed"
	"fmt"
	"math"

	"github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func TryDirection(ic *intcode.IntCode) *intcode.IntCode {
	for !ic.Done() {
		ic.Run()
		if ic.OutLen() == 1 {
			return ic
		}
	}
	panic("IntCode error")
}

type SearchRecord struct {
	pos   Point
	steps int
	ic    *intcode.IntCode
}

type Search []SearchRecord

type Ship struct {
	wall  map[Point]bool
	bb    *BoundingBox
	os    *Point
	osic  *intcode.IntCode
	steps int
}

func NewShip() *Ship {
	return &Ship{make(map[Point]bool), NewBoundingBox(), nil, nil, 0}
}

func CompassToInput(c Compass) int64 {
	switch c {
	case "N":
		return 1
	case "S":
		return 2
	case "W":
		return 3
	case "E":
		return 4
	default:
		panic(fmt.Sprintf("Invalid compass direction %s\n", c))
		return -1
	}
}

func (s *Ship) String() string {
	str := ""
	for y := s.bb.Min.Y; y <= s.bb.Max.Y; y++ {
		for x := s.bb.Min.X; x <= s.bb.Max.X; x++ {
			if x == 0 && y == 0 {
				str += "S"
			} else if s.os != nil && x == s.os.X && y == s.os.Y {
				str += "E"
			} else if v, ok := s.wall[Point{x, y}]; ok && v {
				str += "#"
			} else {
				str += "."
			}
		}
		str += "\n"
	}
	return str
}

func part1(p []int64) *Ship {
	search := Search{}
	ship := NewShip()
	start := &Point{0, 0}
	for _, compass := range []Compass{"N", "S", "E", "W"} {
		np := start.In(compass.Direction())
		search = append(search,
			SearchRecord{np, 1,
				intcode.NewIntCode(p, []int64{CompassToInput(compass)})})
	}
	visited := make(map[Point]bool)
	visited[*start] = true
	count := 0
	for len(search) > 0 {
		count++
		// if count%100 == 0 {
		// 	fmt.Printf("%s\ntodo=%d\n", ship, len(search))
		// }
		cur := search[0]
		search = search[1:]
		ic := TryDirection(cur.ic)
		res := ic.Out(1)[0]
		ship.bb.Add(cur.pos)
		if res == 0 { // wall
			ship.wall[cur.pos] = true
		} else if res == 1 {
			for _, compass := range []Compass{"N", "S", "E", "W"} {
				np := cur.pos.In(compass.Direction())
				if _, ok := visited[np]; ok {
					continue
				}
				visited[np] = true
				search = append(search,
					SearchRecord{np,
						cur.steps + 1,
						ic.ForkWithInput(CompassToInput(compass))})
			}
		} else if res == 2 { // found
			ship.os = &cur.pos
			ship.osic = cur.ic
			ship.steps = cur.steps
		}
	}
	return ship
}

func part2(ship *Ship) int {
	search := Search{}
	start := ship.os
	for _, compass := range []Compass{"N", "S", "E", "W"} {
		np := start.In(compass.Direction())
		search = append(search,
			SearchRecord{np, 1,
				ship.osic.ForkWithInput(CompassToInput(compass))})
	}
	max := math.MinInt32
	visited := make(map[Point]bool)
	visited[*start] = true
	count := 0
	for len(search) > 0 {
		count++
		// if count%100 == 0 {
		// 	fmt.Printf("%s\ntodo=%d max=%d\n", ship, len(search), max)
		// }
		cur := search[0]
		search = search[1:]
		ic := TryDirection(cur.ic)
		res := ic.Out(1)[0]
		ship.bb.Add(cur.pos)
		if res == 0 { // wall
			ship.wall[cur.pos] = true
		} else if res == 1 {
			if cur.steps > max {
				max = cur.steps
			}
			for _, compass := range []Compass{"N", "S", "E", "W"} {
				np := cur.pos.In(compass.Direction())
				if _, ok := visited[np]; ok {
					continue
				}
				visited[np] = true
				search = append(search,
					SearchRecord{np,
						cur.steps + 1,
						ic.ForkWithInput(CompassToInput(compass))})
			}
		} else if res == 2 { // found again?
			panic("found again?")
		}
	}
	return max
}

func main() {
	p := FastInt64s(InputBytes(input), 4096)
	s := part1(p)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", s.steps)
	}
	p2 := part2(s)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
