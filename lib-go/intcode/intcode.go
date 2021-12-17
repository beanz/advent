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

type IntCodeInst struct {
	op    int64
	param []int64
	addr  []int
}

func OpArity(op int64) int {
	if op == 99 {
		return 0
	}
	return []int{0, 3, 3, 1, 1, 2, 2, 3, 3, 1}[op]
}

func (ic *IntCode) Done() bool {
	return ic.done
}

func (ic *IntCode) ForkWithInput(input int64) *IntCode {
	prog := make([]int64, len(ic.p))
	copy(prog, ic.p)
	return &IntCode{prog, ic.ip, ic.base,
		[]int64{input}, []int64{}, false, false}
}

func (ic *IntCode) sprog(i int) int64 {
	for len(ic.p) <= i {
		ic.p = append(ic.p, 0)
	}
	return ic.p[i]
}

func (ic *IntCode) ParseInst() (IntCodeInst, error) {
	rawOp := ic.p[ic.ip]
	ic.ip++
	op := rawOp % 100
	arity := OpArity(op)
	mode := []int64{
		(rawOp / 100) % 10,
		(rawOp / 1000) % 10,
		(rawOp / 10000) % 10,
	}

	param := make([]int64, 0, 4)
	addr := make([]int, 0, 4)
	for i := 0; i < arity; i++ {
		switch mode[i] {
		case 1:
			param = append(param, ic.p[ic.ip])
			addr = append(addr, -99)
		case 2:
			param = append(param, ic.sprog(ic.base+int(ic.p[ic.ip])))
			addr = append(addr, ic.base+int(ic.p[ic.ip]))
		default:
			param = append(param, ic.sprog(int(ic.p[ic.ip])))
			addr = append(addr, int(ic.p[ic.ip]))
		}
		ic.ip++
	}
	return IntCodeInst{op, param, addr}, nil
}

func (ic *IntCode) Run() RunExitStatus {
	for {
		if ic.debug {
			fmt.Printf("%s\n", ic)
		}
		inst, err := ic.ParseInst()
		if err != nil {
			panic(err)
		}
		op := inst.op
		switch op {
		case 1:
			if ic.debug {
				fmt.Printf("1: %d + %d = %d => %d\n",
					inst.param[0], inst.param[1],
					inst.param[0]+inst.param[1], inst.addr[2])
			}
			ic.p[inst.addr[2]] = inst.param[0] + inst.param[1]
		case 2:
			if ic.debug {
				fmt.Printf("2: %d * %d = %d => %d\n",
					inst.param[0], inst.param[1],
					inst.param[0]*inst.param[1], inst.addr[2])
			}
			ic.p[inst.addr[2]] = inst.param[0] * inst.param[1]
		case 3:
			if len(ic.in) == 0 {
				ic.ip -= 2
				return NeedInput
			}
			if ic.debug {
				fmt.Printf("3: %d => %d\n", ic.in[0], inst.addr[0])
			}
			ic.p[inst.addr[0]] = ic.in[0]
			ic.in = ic.in[1:]
		case 4:
			if ic.debug {
				fmt.Printf("4: %d => out\n", inst.param[0])
			}
			ic.out = append(ic.out, inst.param[0])
			return ProducedOutput
		case 5:
			if ic.debug {
				fmt.Printf("5: jnz %d to %d\n", inst.param[0], inst.param[1])
			}
			if inst.param[0] != 0 {
				ic.ip = int(inst.param[1])
			}
		case 6:
			if ic.debug {
				fmt.Printf("6: jz %d to %d\n", inst.param[0], inst.param[1])
			}
			if inst.param[0] == 0 {
				ic.ip = int(inst.param[1])
			}
		case 7:
			if ic.debug {
				fmt.Printf("7: %d < %d => %d\n",
					inst.param[0], inst.param[1], inst.addr[2])
			}
			if inst.param[0] < inst.param[1] {
				ic.p[inst.addr[2]] = 1
			} else {
				ic.p[inst.addr[2]] = 0
			}
		case 8:
			if ic.debug {
				fmt.Printf("8: %d == %d => %d\n",
					inst.param[0], inst.param[1], inst.addr[2])
			}
			if inst.param[0] == inst.param[1] {
				ic.p[inst.addr[2]] = 1
			} else {
				ic.p[inst.addr[2]] = 0
			}
		case 9:
			if ic.debug {
				fmt.Printf("9: %d => base\n", inst.param[0])
			}
			ic.base += int(inst.param[0])
		case 99:
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
