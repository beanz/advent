package main

import (
	"fmt"
	"log"
	"os"
	// "time"

	. "github.com/beanz/advent-of-code-go"
)

type IntCode struct {
	p     []int
	ip    int
	base  int
	in    func() int
	out   []int
	done  bool
	debug bool
}

func (g *IntCode) String() string {
	l := g.ip + 10
	if l >= len(g.p) {
		l = len(g.p) - 1
	}
	s := fmt.Sprintf("ip=%d %v %d %v", g.ip, g.p[g.ip:l], g.base, g.done)
	return s
}

func NewIntCode(p []int, input func() int) *IntCode {
	prog := make([]int, len(p))
	copy(prog, p)
	g := &IntCode{prog, 0, 0, input, []int{}, false, false}
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

func (g *IntCode) Done() bool {
	return g.done
}

func (g *IntCode) sprog(i int) int {
	for len(g.p) <= i {
		g.p = append(g.p, 0)
	}
	return g.p[i]
}

func (g *IntCode) ParseInst() (TestInst, error) {
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

func (g *IntCode) Run() int {
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
			v := g.in()
			//fmt.Printf("3: %d => %d\n", v, inst.addr[0])
			g.p[inst.addr[0]] = v
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

func run(p []int, input func() int, reader func(int, int, int)) {
	ic := NewIntCode(p, input)
	for !ic.Done() {
		ic.Run()
		if len(ic.out) == 3 {
			reader(ic.out[0], ic.out[1], ic.out[2])
			ic.out = ic.out[3:]
		}
	}
	return
}

func part1(p []int) int {
	blocks := 0
	run(p,
		func() int {
			return 0
		},
		func(x, y, t int) {
			if t == 2 {
				blocks++
			}
		})
	return blocks
}

func part2(p []int) int {
	paddle := 0
	ball := 0
	score := 0
	p[0] = 2
	// fmt.Fprintf(os.Stderr, "\033[3K\033[H\033[2J") // clear
	run(p,
		func() int {
			if ball < paddle {
				return -1
			} else if ball > paddle {
				return 1
			}
			return 0
		},
		func(x, y, t int) {
			if x == -1 && y == 0 {
				score = t
				return
			} else if t == 3 {
				paddle = x
			} else if t == 4 {
				ball = x
			}
			// fmt.Fprintf(os.Stderr,
			// 	"\033[%d;%dH%s", y+1, x+1,
			// 	[]string{" ", "#", "=", "-", "o"}[t])
			// time.Sleep(2 * time.Millisecond)
		})
	return score
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p := SimpleReadInts(lines[0])
	fmt.Printf("Part 1: %d\n", part1(p))
	p = SimpleReadInts(lines[0])
	fmt.Printf("Part 2: %d\n", part2(p))
}
