package main

import (
	"fmt"
	"math"

	aoc "github.com/beanz/advent/lib-go"
)

type IntCode struct {
	p     []int
	ip    int
	base  int
	in    []int
	out   []int
	done  bool
	debug bool
}

func (ic *IntCode) String() string {
	l := ic.ip + 10
	if l >= len(ic.p) {
		l = len(ic.p) - 1
	}
	s := fmt.Sprintf("ip=%d %v %d %v", ic.ip, ic.p[ic.ip:l], ic.base, ic.done)
	return s
}

func NewIntCode(p []int, input int) *IntCode {
	prog := make([]int, len(p))
	copy(prog, p)
	ic := &IntCode{prog, 0, 0, []int{input}, []int{}, false, false}
	return ic
}

type TestInst struct {
	op    int
	param []int
	addr  []int
}

func OpArity(op int) int {
	if op == 99 {
		return 0
	}
	return []int{0, 3, 3, 1, 1, 2, 2, 3, 3, 1}[op]
}

func (ic *IntCode) Done() bool {
	return ic.done
}

func (ic *IntCode) ForkWithInput(input int) *IntCode {
	prog := make([]int, len(ic.p))
	copy(prog, ic.p)
	return &IntCode{prog, ic.ip, ic.base, []int{input}, []int{}, false, false}
}

func (ic *IntCode) sprog(i int) int {
	for len(ic.p) <= i {
		ic.p = append(ic.p, 0)
	}
	return ic.p[i]
}

func (ic *IntCode) ParseInst() (TestInst, error) {
	rawOp := ic.p[ic.ip]
	ic.ip++
	op := rawOp % 100
	arity := OpArity(op)
	mode := []int{
		(rawOp / 100) % 10,
		(rawOp / 1000) % 10,
		(rawOp / 10000) % 10,
	}

	var param []int
	var addr []int
	for i := 0; i < arity; i++ {
		switch mode[i] {
		case 1:
			param = append(param, ic.p[ic.ip])
			addr = append(addr, -99)
		case 2:
			param = append(param, ic.sprog(ic.base+ic.p[ic.ip]))
			addr = append(addr, ic.base+ic.p[ic.ip])
		default:
			param = append(param, ic.sprog(ic.p[ic.ip]))
			addr = append(addr, ic.p[ic.ip])
		}
		ic.ip++
	}
	return TestInst{op, param, addr}, nil
}

func (ic *IntCode) Run() int {
	for {
		//fmt.Printf("%v\n", g)
		inst, err := ic.ParseInst()
		if err != nil {
			panic(err)
		}
		op := inst.op
		switch op {
		case 1:
			//fmt.Printf("1: %d + %d = %d => %d\n",
			//	inst.param[0], inst.param[1],
			//	inst.param[0]+inst.param[1], inst.addr[2])
			ic.p[inst.addr[2]] = inst.param[0] + inst.param[1]
		case 2:
			//fmt.Printf("2: %d * %d = %d => %d\n",
			//	inst.param[0], inst.param[1],
			//	inst.param[0]*inst.param[1], inst.addr[2])
			ic.p[inst.addr[2]] = inst.param[0] * inst.param[1]
		case 3:
			if len(ic.in) == 0 {
				//fmt.Printf("3: %d => %d\n", 0, inst.addr[0])
				ic.p[inst.addr[0]] = 0
			} else {
				//fmt.Printf("3: %d => %d\n", ic.in[0], inst.addr[0])
				ic.p[inst.addr[0]] = ic.in[0]
				ic.in = ic.in[1:]
			}
		case 4:
			//fmt.Printf("4: %d => out\n", inst.param[0])
			ic.out = append(ic.out, inst.param[0])
			return 0
		case 5:
			//fmt.Printf("5: jnz %d to %d\n", inst.param[0], inst.param[1])
			if inst.param[0] != 0 {
				ic.ip = inst.param[1]
			}
		case 6:
			//fmt.Printf("6: jz %d to %d\n", inst.param[0], inst.param[1])
			if inst.param[0] == 0 {
				ic.ip = inst.param[1]
			}
		case 7:
			if inst.param[0] < inst.param[1] {
				ic.p[inst.addr[2]] = 1
			} else {
				ic.p[inst.addr[2]] = 0
			}
		case 8:
			if inst.param[0] == inst.param[1] {
				ic.p[inst.addr[2]] = 1
			} else {
				ic.p[inst.addr[2]] = 0
			}
		case 9:
			ic.base += inst.param[0]
		case 99:
			ic.done = true
			return 1
		default:
			ic.done = true
			return -1
		}
		//fmt.Printf("%v\n", ic.p)
	}
	return -2
}

func (ic *IntCode) TryDirection() *IntCode {
	for !ic.Done() {
		ic.Run()
		if len(ic.out) == 1 {
			return ic
		}
	}
	panic("IntCode error")
}

type SearchRecord struct {
	pos   aoc.Point
	steps int
	ic    *IntCode
}

type Search []SearchRecord

type Ship struct {
	wall  map[aoc.Point]bool
	bb    *aoc.BoundingBox
	os    *aoc.Point
	osic  *IntCode
	steps int
}

func NewShip() *Ship {
	return &Ship{make(map[aoc.Point]bool), aoc.NewBoundingBox(), nil, nil, 0}
}

func CompassToInput(c aoc.Compass) int {
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
			} else if v, ok := s.wall[aoc.Point{x, y}]; ok && v {
				str += "#"
			} else {
				str += "."
			}
		}
		str += "\n"
	}
	return str
}

func part1(p []int) *Ship {
	search := Search{}
	ship := NewShip()
	start := &aoc.Point{0, 0}
	for _, compass := range []aoc.Compass{"N", "S", "E", "W"} {
		np := start.In(compass.Direction())
		search = append(search,
			SearchRecord{np, 1, NewIntCode(p, CompassToInput(compass))})
	}
	visited := make(map[aoc.Point]bool)
	visited[*start] = true
	count := 0
	for len(search) > 0 {
		count++
		// if count%100 == 0 {
		// 	fmt.Printf("%s\ntodo=%d\n", ship, len(search))
		// }
		cur := search[0]
		search = search[1:]
		ic := cur.ic.TryDirection()
		res := ic.out[0]
		ic.out = ic.out[1:]
		ship.bb.Add(cur.pos)
		if res == 0 { // wall
			ship.wall[cur.pos] = true
		} else if res == 1 {
			for _, compass := range []aoc.Compass{"N", "S", "E", "W"} {
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
	for _, compass := range []aoc.Compass{"N", "S", "E", "W"} {
		np := start.In(compass.Direction())
		search = append(search,
			SearchRecord{np, 1,
				ship.osic.ForkWithInput(CompassToInput(compass))})
	}
	max := math.MinInt32
	visited := make(map[aoc.Point]bool)
	visited[*start] = true
	count := 0
	for len(search) > 0 {
		count++
		// if count%100 == 0 {
		// 	fmt.Printf("%s\ntodo=%d max=%d\n", ship, len(search), max)
		// }
		cur := search[0]
		search = search[1:]
		ic := cur.ic.TryDirection()
		res := ic.out[0]
		ic.out = ic.out[1:]
		ship.bb.Add(cur.pos)
		if res == 0 { // wall
			ship.wall[cur.pos] = true
		} else if res == 1 {
			if cur.steps > max {
				max = cur.steps
			}
			for _, compass := range []aoc.Compass{"N", "S", "E", "W"} {
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
	lines := aoc.ReadInputLines()
	p := aoc.SimpleReadInts(lines[0])
	s := part1(p)
	fmt.Printf("Part 1: %d\n", s.steps)
	fmt.Printf("Part 2: %d\n", part2(s))
}
