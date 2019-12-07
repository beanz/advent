package main

import (
	"fmt"
	"log"
	"math"
	"os"
	//"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Game struct {
	p     []int
	ip    int
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
	s := fmt.Sprintf("ip=%d %v [%v] %v", g.ip, g.p[g.ip:l], g.in, g.done)
	return s
}

func NewGame(p []int, phase int) *Game {
	prog := make([]int, len(p))
	copy(prog, p)
	g := &Game{prog, 0, []int{phase}, []int{}, false, false}
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

func (g *Game) Done() bool {
	return g.done
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

func tryPhase(p []int, phase []int) int {
	u := make([]*Game, len(phase))
	for i := 0; i < len(phase); i++ {
		u[i] = NewGame(p, phase[i])
	}
	done := 0
	last := 0
	out := 0
	first := true
	for done != len(phase) {
		done = 0
		for i := 0; i < len(phase); i++ {
			//fmt.Printf("Running unit %d: %v\n", i, u[i])
			g := u[i]
			if g.Done() {
				done++
			} else {
				if !first {
					g.in = append(g.in, out)
				}
				rc := g.Run()
				if len(g.out) != 0 {
					out = g.out[0]
					g.out = g.out[1:]
					last = out
					//fmt.Printf("unit %d gave output %d\n", i, out)
				}
				if rc == 1 || rc == -1 {
					//fmt.Printf("unit %d halted %d\n", i, rc)
					done++
				}
			}
			first = false
		}
	}
	return last
}

func run(p []int, minPhase int, maxPhase int) int {
	perm := Permutations(minPhase, maxPhase)
	max := math.MinInt64
	for _, v := range perm {
		thrust := tryPhase(p, v)
		if max < thrust {
			max = thrust
		}
	}
	return max
}

func part1(p []int) int {
	return run(p, 0, 4)
}

func part2(p []int) int {
	return run(p, 5, 9)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p := SimpleReadInts(lines[0])
	fmt.Printf("Part 1: %d\n", part1(p))
	fmt.Printf("Part 2: %d\n", part2(p))
}
