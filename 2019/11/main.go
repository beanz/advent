package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Game struct {
	p     []int
	ip    int
	base  int
	in    []int
	out   []int
	done  bool
	debug bool
}

func (g *Game) String() string {
	l := g.ip + 10
	if l >= len(g.p) {
		l = len(g.p) - 1
	}
	s := fmt.Sprintf("ip=%d %v %d %v", g.ip, g.p[g.ip:l], g.base, g.done)
	return s
}

func NewGame(p []int, input int) *Game {
	prog := make([]int, len(p))
	copy(prog, p)
	g := &Game{prog, 0, 0, []int{input}, []int{}, false, false}
	return g
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

func (g *Game) Done() bool {
	return g.done
}

func (g *Game) sprog(i int) int {
	for len(g.p) <= i {
		g.p = append(g.p, 0)
	}
	return g.p[i]
}

func (g *Game) ParseInst() (TestInst, error) {
	rawOp := g.p[g.ip]
	g.ip++
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
			param = append(param, g.p[g.ip])
			addr = append(addr, -99)
		case 2:
			param = append(param, g.sprog(g.base+g.p[g.ip]))
			addr = append(addr, g.base+g.p[g.ip])
		default:
			param = append(param, g.sprog(g.p[g.ip]))
			addr = append(addr, g.p[g.ip])
		}
		g.ip++
	}
	return TestInst{op, param, addr}, nil
}

func (g *Game) Run() int {
	for {
		//fmt.Printf("%v\n", g)
		inst, err := g.ParseInst()
		if err != nil {
			panic(err)
		}
		op := inst.op
		switch op {
		case 1:
			//fmt.Printf("1: %d + %d = %d => %d\n",
			//	inst.param[0], inst.param[1],
			//	inst.param[0]+inst.param[1], inst.addr[2])
			g.p[inst.addr[2]] = inst.param[0] + inst.param[1]
		case 2:
			//fmt.Printf("2: %d * %d = %d => %d\n",
			//	inst.param[0], inst.param[1],
			//	inst.param[0]*inst.param[1], inst.addr[2])
			g.p[inst.addr[2]] = inst.param[0] * inst.param[1]
		case 3:
			if len(g.in) == 0 {
				//fmt.Printf("3: %d => %d\n", 0, inst.addr[0])
				g.p[inst.addr[0]] = 0
			} else {
				//fmt.Printf("3: %d => %d\n", g.in[0], inst.addr[0])
				g.p[inst.addr[0]] = g.in[0]
				g.in = g.in[1:]
			}
		case 4:
			//fmt.Printf("4: %d => out\n", inst.param[0])
			g.out = append(g.out, inst.param[0])
			return 0
		case 5:
			//fmt.Printf("5: jnz %d to %d\n", inst.param[0], inst.param[1])
			if inst.param[0] != 0 {
				g.ip = inst.param[1]
			}
		case 6:
			//fmt.Printf("6: jz %d to %d\n", inst.param[0], inst.param[1])
			if inst.param[0] == 0 {
				g.ip = inst.param[1]
			}
		case 7:
			if inst.param[0] < inst.param[1] {
				g.p[inst.addr[2]] = 1
			} else {
				g.p[inst.addr[2]] = 0
			}
		case 8:
			if inst.param[0] == inst.param[1] {
				g.p[inst.addr[2]] = 1
			} else {
				g.p[inst.addr[2]] = 0
			}
		case 9:
			g.base += inst.param[0]
		case 99:
			g.done = true
			return 1
		default:
			g.done = true
			return -1
		}
		//fmt.Printf("%v\n", g.p)
	}
	return -2
}

type Hull struct {
	pos Point
	dir Direction
	m   map[Point]bool
	bb  *BoundingBox
}

func NewHull() *Hull {
	return &Hull{Point{0, 0}, Direction{0, -1},
		make(map[Point]bool), NewBoundingBox()}
}

func (h *Hull) input() int {
	if v, ok := h.m[h.pos]; !ok || !v {
		return 0
	}
	return 1
}

func (h *Hull) output(val int) {
	h.m[h.pos] = val == 1
}

func (h *Hull) processOutput(col, turn int) {
	h.output(col)
	if turn == 1 {
		h.dir = h.dir.CW()
	} else {
		h.dir = h.dir.CCW()
	}
	h.pos = h.pos.In(h.dir)
	h.bb.Add(h.pos)
}

func run(p []int, input int) *Hull {
	h := NewHull()
	ic := NewGame(p, input)
	for !ic.Done() {
		ic.Run()
		if len(ic.out) == 2 {
			h.processOutput(ic.out[0], ic.out[1])
			ic.out = ic.out[2:]
			ic.in = append(ic.in, h.input())
		}
	}
	return h
}

func part1(p []int) int {
	h := run(p, 0)
	return len(h.m)
}

func part2(p []int) string {
	h := run(p, 1)
	s := ""
	for y := h.bb.Min.Y; y <= h.bb.Max.Y; y++ {
		for x := h.bb.Min.X; x <= h.bb.Max.X; x++ {
			if v, ok := h.m[Point{x, y}]; ok && v {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p := SimpleReadInts(lines[0])
	fmt.Printf("Part 1: %d\n", part1(p))
	fmt.Printf("Part 2:\n%s", part2(p))
}