package main

import (
	"fmt"

	aoc "github.com/beanz/advent/lib-go"
)

type Game struct {
	p     []int
	ip    int
	out   []int
	debug bool
}

func (g *Game) String() string {
	l := g.ip + 10
	if l >= len(g.p) {
		l = len(g.p) - 1
	}
	s := fmt.Sprintf("ip=%d %v", g.ip, g.p[g.ip:l])
	return s
}

func NewGame(p []int) *Game {
	g := &Game{p, 0, []int{}, false}
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
	return []int{0, 3, 3, 1, 1, 2, 2, 3, 3}[op]
}

func (g *Game) ParseInst() (TestInst, error) {
	rawOp := g.p[g.ip]
	g.ip++
	op := rawOp % 100
	arity := OpArity(op)
	immediate := []bool{
		(rawOp/100)%10 == 1,
		(rawOp/1000)%10 == 1,
		(rawOp/10000)%10 == 1,
	}
	var param []int
	var addr []int
	for i := 0; i < arity; i++ {
		if immediate[i] {
			param = append(param, g.p[g.ip])
			addr = append(addr, -99)
		} else {
			param = append(param, g.p[g.p[g.ip]])
			addr = append(addr, g.p[g.ip])
		}
		g.ip++
	}
	return TestInst{op, param, addr}, nil
}

func (g *Game) Run(in int) (int, bool) {
	g.ip = 0
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
			//fmt.Printf("3: %d => %d\n", in, inst.addr[0])
			g.p[inst.addr[0]] = in
		case 4:
			g.out = append(g.out, inst.param[0])
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
		case 99:
			return g.p[0], true
		default:
			return -1, false
		}
		//fmt.Printf("%v\n", g.p)
	}
	return -1, false
}

func (g *Game) Part1() int {
	g.Run(1)
	return g.out[len(g.out)-1]
}

func (g *Game) Part2() int {
	g.Run(5)
	return g.out[0]
}

func main() {
	lines := aoc.ReadInputLines()
	p := aoc.SimpleReadInts(lines[0])
	g := NewGame(p)
	fmt.Printf("Part 1: %d\n", g.Part1())
	p = aoc.SimpleReadInts(lines[0])
	g = NewGame(p)
	fmt.Printf("Part 2: %d\n", g.Part2())
}
