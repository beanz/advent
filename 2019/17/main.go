package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"strings"

	. "github.com/beanz/advent-of-code-go"
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

func NewIntCode(p []int, input []int) *IntCode {
	prog := make([]int, len(p))
	copy(prog, p)
	ic := &IntCode{prog, 0, 0, input, []int{}, false, false}
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

func (ic *IntCode) RunToHalt() []int {
	for !ic.Done() {
		ic.Run()
	}
	return ic.out
}

type SearchRecord struct {
	pos   Point
	steps int
	ic    *IntCode
}

type Search []SearchRecord

type Scaffold struct {
	m   map[Point]bool
	bb  *BoundingBox
	pos Point
	bot Point
	dir Direction
}

func NewScaffold() *Scaffold {
	return &Scaffold{make(map[Point]bool), NewBoundingBox(),
		Point{0, 0}, Point{-1, -1}, Direction{0, -1}}
}

func (s *Scaffold) String() string {
	str := ""
	for y := s.bb.Min.Y; y <= s.bb.Max.Y; y++ {
		for x := s.bb.Min.X; x <= s.bb.Max.X; x++ {
			if s.bot.X == x && s.bot.Y == y {
				str += "^"
			} else if s.IsPipe(Point{x, y}) {
				str += "#"
			} else {
				str += "."
			}
		}
		str += "\n"
	}
	return str
}

func (s *Scaffold) IsPipe(p Point) bool {
	v, ok := s.m[p]
	return ok && v
}

func (s *Scaffold) AlignmentSum() int {
	ans := 0
	for y := s.bb.Min.Y; y <= s.bb.Max.Y; y++ {
		for x := s.bb.Min.X; x <= s.bb.Max.X; x++ {
			if s.IsPipe(Point{x, y}) &&
				s.IsPipe(Point{x - 1, y}) &&
				s.IsPipe(Point{x, y - 1}) &&
				s.IsPipe(Point{x + 1, y}) &&
				s.IsPipe(Point{x, y + 1}) {
				ans += x * y
			}
		}
	}
	return ans
}

func part1(p []int) *Scaffold {
	ic := NewIntCode(p, []int{})
	output := ic.RunToHalt()
	scaff := NewScaffold()
	for _, ascii := range output {
		switch ascii {
		case 10:
			scaff.pos.X = 0
			scaff.pos.Y++
		case 35:
			scaff.m[scaff.pos] = true
			scaff.pos.X++
		case 94:
			scaff.m[scaff.pos] = true
			scaff.bot = Point{scaff.pos.X, scaff.pos.Y}
			scaff.pos.X++
		default:
			scaff.pos.X++
		}
		scaff.bb.Add(scaff.pos)
	}
	fmt.Printf("%s\n", scaff)
	return scaff
}

func turnsFor(d Direction) []Direction {
	if d.Dx == 0 {
		if d.Dy == -1 {
			return []Direction{Direction{-1, 0}, Direction{1, 0}}
		} else {
			return []Direction{Direction{1, 0}, Direction{-1, 0}}
		}
	} else if d.Dx == -1 {
		return []Direction{Direction{0, 1}, Direction{0, -1}}
	} else {
		return []Direction{Direction{0, -1}, Direction{0, 1}}
	}
}

func nextFunc(path string, off int, ch string) string {
	shortest := math.MaxInt64
	fun := ""
	for i := 1; i < 22; i++ {
		sub := path[off : off+i-1]
		t := strings.Replace(path, sub, ch, -1)
		if shortest > len(t) {
			shortest = len(t)
			fun = sub
		}
	}
	fun = strings.TrimRight(fun, ",RL")
	return fun
}

func part2(p []int, scaff *Scaffold) int {
	pos := scaff.bot
	dir := scaff.dir
	path := []string{}
	for {
		np := pos.In(dir)
		if scaff.IsPipe(np) {
			//fmt.Printf("Move forward to %s\n", np)
			pos = np
			if len(path) > 0 {
				if steps, err := strconv.Atoi(path[len(path)-1]); err == nil {
					path[len(path)-1] = fmt.Sprintf("%d", steps+1)
				} else {
					path = append(path, "1")
				}
			} else {
				path = append(path, "1")
			}
		} else {
			turns := turnsFor(dir)
			np := pos.In(turns[0])
			if scaff.IsPipe(np) {
				//fmt.Printf("Turn left\n")
				dir = turns[0]
				path = append(path, "L")
			} else {
				np := pos.In(turns[1])
				if scaff.IsPipe(np) {
					//fmt.Printf("Turn right\n")
					dir = turns[1]
					path = append(path, "R")
				} else {
					break
				}
			}
		}
	}
	pathStr := strings.Join(path, ",")
	//fmt.Printf("Path: %s\n", pathStr)
	funA := nextFunc(pathStr, 0, "A")
	//fmt.Printf("A: %s\n", funA)
	pathStr = strings.Replace(pathStr, funA, "A", -1)
	off := 0
	for pathStr[off] == 'A' || pathStr[off] == ',' {
		off++
	}
	//fmt.Printf("Path after A: %s\n", pathStr)
	//fmt.Printf("Offset after A: %d\n", off)
	funB := nextFunc(pathStr, off, "B")
	//fmt.Printf("B: %s\n", funB)
	pathStr = strings.Replace(pathStr, funB, "B", -1)
	for pathStr[off] == 'A' || pathStr[off] == 'B' || pathStr[off] == ',' {
		off++
	}
	//fmt.Printf("Path after B: %s\n", pathStr)
	//fmt.Printf("Offset after B: %d\n", off)
	funC := nextFunc(pathStr, off, "C")
	//fmt.Printf("C: %s\n", funC)
	pathStr = strings.Replace(pathStr, funC, "C", -1)
	//fmt.Printf("Path after C: %s\n", pathStr)
	funM := pathStr

	inputStr := strings.Join([]string{funM, funA, funB, funC, "n\n"}, "\n")
	inp := []int{}
	for _, r := range inputStr {
		inp = append(inp, int(r))
	}
	p[0] = 2
	ic := NewIntCode(p, inp)
	output := ic.RunToHalt()
	return output[len(output)-1]
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p := SimpleReadInts(lines[0])
	scaff := part1(p)
	fmt.Printf("Part 1: %d\n", scaff.AlignmentSum())
	fmt.Printf("Part 2: %d\n", part2(p, scaff))
}
