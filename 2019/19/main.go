package main

import (
	"fmt"
	"log"
	"os"

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

type Beam struct {
	prog   []int
	size   int
	mul    int
	ratio1 int
	ratio2 int
}

func NewBeam(p []int) *Beam {
	return &Beam{p, 100 - 1, 1, 1, 1}
}

func (b *Beam) inBeam(x int, y int) bool {
	ic := NewIntCode(b.prog, []int{x, y})
	ic.Run()
	return ic.out[0] == 1
}

func (b *Beam) part1() int {
	count := 0
	first := -1
	last := -1
	for y := 0; y < 50; y++ {
		first = -1
		last = -1
		for x := 0; x < 50; x++ {
			if b.inBeam(x, y) {
				if first == -1 {
					first = x
				}
				last = x
				count++
			}

		}
	}
	b.ratio1 = first
	b.ratio2 = last
	b.mul = 49
	return count
}

func (b *Beam) findRatios(y int) {
	first := 49
	for !b.inBeam(first, y) {
		first++
	}
	last := first
	for b.inBeam(last, y) {
		last++
	}
	b.ratio1 = first
	b.ratio2 = last
}

func (b *Beam) squareFits(x int, y int) bool {
	return b.inBeam(x, y) && b.inBeam(x+b.size, y) &&
		b.inBeam(x, y+b.size) // not necessary! && b.inBeam(x+99, y+99)
}

func (b *Beam) squareFitsY(y int) int {
	min := (y * b.ratio1 / b.mul)
	max := (y * b.ratio2 / b.mul)
	for x := min; x <= max; x++ {
		if b.squareFits(x, y) {
			return x
		}
	}
	return 0
}

func (b *Beam) part2() int {
	if b.ratio1 == -1 {
		b.findRatios(49)
	}
	upper := 1
	for b.squareFitsY(upper) == 0 {
		upper *= 2
		// fmt.Printf(" ^ %d\n", upper)
	}
	lower := upper / 2
	for {
		mid := lower + (upper-lower)/2
		if mid == lower {
			break
		}
		if b.squareFitsY(mid) > 0 {
			upper = mid
		} else {
			lower = mid
		}
		// fmt.Printf("%d ... %d\n", lower, upper)
	}

	var x int
	var y int
	for y = lower; y < lower+5; y++ {
		x = b.squareFitsY(y)
		if x > 0 {
			break
		}
	}
	return x*10000 + y
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p := SimpleReadInts(lines[0])
	beam := NewBeam(p)
	fmt.Printf("Part 1: %d\n", beam.part1())
	fmt.Printf("Part 2: %d\n", beam.part2())
}
