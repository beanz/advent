package intcode

import (
	"fmt"
	"os"
)

type RunExitStatus int

const (
	Finished RunExitStatus = iota
	FinishedOpError
	NeedInput
	ProducedOutput
)

type IntCode struct {
	p     []int64
	ip    int
	base  int
	in    []int64
	out   []int64
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

func NewIntCode(p []int64, input []int64) *IntCode {
	prog := make([]int64, len(p))
	copy(prog, p)
	out := make([]int64, 0, 32)
	ic := &IntCode{prog, 0, 0, input, out, false,
		os.Getenv("INTCODE_DEBUG")!=""}
	return ic
}

func NewIntCodeFromASCII(p []int64, ascii string) *IntCode {
	input := []int64{}
	for _, r := range ascii {
		input = append(input, int64(r))
	}
	return NewIntCode(p, input)
}

func (ic *IntCode) OutLen() int {
	return len(ic.out)
}

func (ic *IntCode) Out(n int) []int64 {
	res := []int64{}
	if len(ic.out) >= n {
		for i := 0; i < n; i++ {
			res = append(res, ic.out[i])
		}
		ic.out = ic.out[n:]
	}
	return res
}

func (ic *IntCode) In(inputs ...int64) {
	ic.in = append(ic.in, inputs...)
}

func (ic *IntCode) InStr(input string) {
	for _, r := range input {
		ic.in = append(ic.in, int64(r))
	}
}

type ParamMode int

const (
	PositionMode ParamMode = 0
	ImmediateMode ParamMode = 1
	BaseMode ParamMode = 2
)

type OpCode int64

const (
	OpAdd = 1
	OpMul = 2
	OpInput  = 3
	OpOutput = 4
	OpJnz = 5
	OpJz = 6
	OpLessThan = 7
	OpEquals = 8
	OpBase = 9
	OpDone = 99
)

func (o OpCode) NoMode() OpCode {
	return OpCode(o%10)
}

func (o OpCode) Mode(i int) ParamMode {
	div := 100
	if i == 1 {
		div = 1000
	} else if i == 2{
		div = 10000
	}
	return ParamMode((int(o)/div)%10)
}

func (ic *IntCode) Done() bool {
	return ic.done
}

func (ic *IntCode) ForkWithInput(input int64) *IntCode {
	prog := make([]int64, len(ic.p))
	copy(prog, ic.p)
	return &IntCode{prog, ic.ip, ic.base,
		[]int64{input}, []int64{}, false, ic.debug}
}

func (ic *IntCode) sprog(i int) int64 {
	for len(ic.p) <= i {
		ic.p = append(ic.p, 0)
	}
	return ic.p[i]
}

func (ic *IntCode) Param(op OpCode, i int) int64 {
	var res int64
	switch op.Mode(i) {
	case 1:
		res = ic.p[ic.ip]
	case 2:
		res = ic.sprog(ic.base+int(ic.p[ic.ip]))
	default:
		res = ic.sprog(int(ic.p[ic.ip]))
	}
	ic.ip++
	return res
}

func (ic *IntCode) Addr(op OpCode, i int) int {
	var res int
	switch op.Mode(i) {
	case 1:
		panic("invalid address?")
	case 2:
		res = ic.base+int(ic.p[ic.ip])
	default:
		res = int(ic.p[ic.ip])
	}
	ic.ip++
	ic.sprog(res)
	return res
}

func (ic *IntCode) Run() RunExitStatus {
	for {
		if ic.debug {
			fmt.Printf("%s\n", ic)
		}
		op := OpCode(ic.p[ic.ip])
		ic.ip++
		switch op.NoMode() {
		case OpAdd:
			p0 := ic.Param(op, 0)
			p1 := ic.Param(op, 1)
			a2 := ic.Addr(op, 2)
			if ic.debug {
				fmt.Printf("1: %d + %d = %d => %d\n", p0, p1, p0 + p1, a2)
			}
			ic.p[a2] = p0 + p1
		case OpMul:
			p0 := ic.Param(op, 0)
			p1 := ic.Param(op, 1)
			a2 := ic.Addr(op, 2)
			if ic.debug {
				fmt.Printf("2: %d * %d = %d => %d\n", p0, p1, p0 * p1, a2)
			}
			ic.p[a2] = p0 * p1
		case OpInput:
			if len(ic.in) == 0 {
				ic.ip--
				return NeedInput
			}
			a0 := ic.Addr(op, 0)
			if ic.debug {
				fmt.Printf("3: %d => %d\n", ic.in[0], a0)
			}
			ic.p[a0] = ic.in[0]
			ic.in = ic.in[1:]
		case OpOutput:
			p0 := ic.Param(op, 0)
			if ic.debug {
				fmt.Printf("4: %d => out\n", p0)
			}
			ic.out = append(ic.out, p0)
			return ProducedOutput
		case OpJnz:
			p0 := ic.Param(op, 0)
			p1 := ic.Param(op, 1)
			if ic.debug {
				fmt.Printf("5: jnz %d to %d\n", p0, p1)
			}
			if p0 != 0 {
				ic.ip = int(p1)
			}
		case OpJz:
			p0 := ic.Param(op, 0)
			p1 := ic.Param(op, 1)
			if ic.debug {
				fmt.Printf("6: jz %d to %d\n", p0, p1)
			}
			if p0 == 0 {
				ic.ip = int(p1)
			}
		case OpLessThan:
			p0 := ic.Param(op, 0)
			p1 := ic.Param(op, 1)
			a2 := ic.Addr(op, 2)
			if ic.debug {
				fmt.Printf("7: %d < %d => %d\n", p0, p1, a2)
			}
			if p0 < p1 {
				ic.p[a2] = 1
			} else {
				ic.p[a2] = 0
			}
		case OpEquals:
			p0 := ic.Param(op, 0)
			p1 := ic.Param(op, 1)
			a2 := ic.Addr(op, 2)
			if ic.debug {
				fmt.Printf("8: %d == %d => %d\n", p0, p1, a2)
			}
			if p0 == p1 {
				ic.p[a2] = 1
			} else {
				ic.p[a2] = 0
			}
		case OpBase:
			p0 := ic.Param(op, 0)
			if ic.debug {
				fmt.Printf("9: %d => base\n", p0)
			}
			ic.base += int(p0)
		case OpDone:
			ic.done = true
			return Finished
		default:
			ic.done = true
			return FinishedOpError
		}
		//fmt.Printf("%v\n", ic.p)
	}
}

func (ic *IntCode) RunToHalt() []int64 {
	for !ic.Done() {
		ic.Run()
	}
	return ic.out
}
