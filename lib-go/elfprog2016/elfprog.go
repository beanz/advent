package elfprog2016

import (
	"fmt"

	aoc "github.com/beanz/advent/lib-go"
)

type InstKind byte

const (
	CopyRR InstKind = iota
	CopyIR
	CopyRI
	CopyII
	Inc
	Dec
	JnzII
	JnzIR
	JnzRI
	JnzRR
	Toggle
	Nop
	Add
	Sub
	Mul
)

func (ik InstKind) String() string {
	switch ik {
	case CopyRR:
		return "cpyrr"
	case CopyIR:
		return "cpyir"
	case CopyRI:
		return "cpyri"
	case Inc:
		return "inc"
	case Dec:
		return "dec"
	case JnzII:
		return "jnzii"
	case JnzRI:
		return "jnzri"
	case JnzIR:
		return "jnzir"
	case Toggle:
		return "tgl"
	case Nop:
		return "nop"
	case Add:
		return "add"
	case Sub:
		return "sub"
	case Mul:
		return "mul"
	default:
		panic("invalid instkind")
	}
}

type Inst struct {
	kind InstKind
	args []int
}

func (i *Inst) String() string {
	return fmt.Sprintf("%s %v", i.kind, i.args)
}

type ElfProg struct {
	inst []*Inst
	ip   int
	reg  [4]int
}

func (p *ElfProg) String() string {
	s := ""
	s += fmt.Sprintf("%d %d %d %d ", p.reg[0], p.reg[1], p.reg[2], p.reg[3])
	s += fmt.Sprintf("%d: %s", p.ip, p.inst[p.ip])
	return s
}

func (p *ElfProg) SetReg(i int, v int) {
	p.reg[i] = v
}

func NewElfProg(in []byte) *ElfProg {
	ep := &ElfProg{make([]*Inst, 0, 128), 0, [4]int{0, 0, 0, 0}}
	for i := 0; i < len(in); {
		switch in[i] {
		case 'c':
			if 'a' <= in[i+4] && in[i+4] <= 'd' {
				if 'a' <= in[i+6] && in[i+6] <= 'd' {
					ep.inst = append(ep.inst,
						&Inst{CopyRR, []int{int(in[i+4] - 'a'), int(in[i+6] - 'a')}})
					i += 8
					break
				}
				v, j := aoc.ScanInt(in, i+6)
				i = j + 1
				ep.inst = append(ep.inst,
					&Inst{CopyRI, []int{int(in[i+4] - 'a'), v}})
			}
			v, j := aoc.ScanInt(in, i+4)
			i = j + 1
			ep.inst = append(ep.inst,
				&Inst{CopyIR, []int{v, int(in[i] - 'a')}})
			i += 2
		case 'i':
			ep.inst = append(ep.inst, &Inst{Inc, []int{int(in[i+4] - 'a')}})
			i += 6
		case 'd':
			ep.inst = append(ep.inst, &Inst{Dec, []int{int(in[i+4] - 'a')}})
			i += 6
		case 'j':
			if 'a' <= in[i+4] && in[i+4] <= 'd' {
				v, j := aoc.ScanInt(in, i+6)
				ep.inst = append(ep.inst,
					&Inst{JnzRI, []int{int(in[i+4] - 'a'), v}})
				i = j + 1
				break
			}
			v1, j := aoc.ScanInt(in, i+4)
			i = j + 1
			if in[i] == 'a' || in[i] == 'b' || in[i] == 'c' || in[i] == 'd' {
				ep.inst = append(ep.inst,
					&Inst{JnzIR, []int{v1, int(in[i] - 'a')}})
				i = i + 2
				break
			}
			v2, j := aoc.ScanInt(in, i)
			i = j + 1
			ep.inst = append(ep.inst, &Inst{JnzII, []int{v1, v2}})
		case 't':
			ep.inst = append(ep.inst, &Inst{Toggle, []int{int(in[i+4] - 'a')}})
			i += 6
		default:
			fmt.Printf("%s\n", string(in[i:]))
			panic("invalid instruction")
		}
	}
	return ep
}

func optimize(prog []*Inst) []*Inst {
	nop := &Inst{Nop, nil}
	opt := make([]*Inst, len(prog))
	for i := 0; i < len(prog); i++ {
		in := prog[i]
		if in.kind == JnzRI && in.args[1] == -2 {
			p1 := prog[i-2]
			p2 := prog[i-1]
			if p2.kind == Dec && in.args[0] == p2.args[0] {
				if p1.kind == Inc {
					opt[i-2] = nop
					opt[i-1] = nop
					opt[i] = &Inst{Add, []int{p1.args[0], in.args[0]}}
					continue
				} else if p1.kind == Dec {
					opt[i-2] = nop
					opt[i-1] = nop
					opt[i] = &Inst{Sub, []int{p1.args[0], in.args[0]}}
					continue
				}
			} else if p1.kind == Dec && in.args[0] == p1.args[0] {
				if p2.kind == Inc {
					opt[i-2] = nop
					opt[i-1] = nop
					opt[i] = &Inst{Add, []int{p2.args[0], in.args[0]}}
					continue
				} else if p2.kind == Dec {
					opt[i-2] = nop
					opt[i-1] = nop
					opt[i] = &Inst{Sub, []int{p2.args[0], in.args[0]}}
					continue
				}
			}
		} else if in.kind == JnzRI && in.args[1] == -5 {
			p1 := opt[i-2]
			p2 := opt[i-1]
			if p2.kind == Dec && in.args[0] == p2.args[0] && p1.kind == Add {
				opt[i-2] = nop
				opt[i-1] = nop
				opt[i] = &Inst{Mul, []int{p1.args[0], p1.args[1], p2.args[0]}}
				continue
			}
		}

		opt[i] = in
	}
	return opt
}

func (p *ElfProg) Run() int {
	p.ip = 0
	opt := optimize(p.inst)
	for p.ip < len(p.inst) {
		in := opt[p.ip]
		//in := p.inst[p.ip]
		//fmt.Printf("%d: %s %v\n", p.ip, in, p.reg)
		switch in.kind {
		case Inc:
			p.reg[in.args[0]]++
		case Dec:
			p.reg[in.args[0]]--
		case CopyRR:
			p.reg[in.args[1]] = p.reg[in.args[0]]
		case CopyIR:
			p.reg[in.args[1]] = in.args[0]
		case CopyII:
			break
			// skip
		case JnzRI:
			v := p.reg[in.args[0]]
			if v != 0 {
				p.ip += in.args[1] - 1 // -1 because we add one every iteration
			}
		case JnzRR:
			v := p.reg[in.args[0]]
			if v != 0 {
				p.ip += p.reg[in.args[1]] - 1 // -1 because we add one every iteration
			}
		case JnzIR:
			v := in.args[0]
			if v != 0 {
				p.ip += p.reg[in.args[1]] - 1 // -1 because we add one every iteration
			}
		case JnzII:
			v := in.args[0]
			if v != 0 {
				p.ip += in.args[1] - 1 // -1 because we add one every iteration
			}
		case Toggle:
			offset := p.reg[in.args[0]]
			offset += p.ip
			if offset < 0 || offset >= len(p.inst) {
				break
			}
			tin := p.inst[offset]
			//fmt.Printf("toggling instruction at %d: %s\n", offset, tin)
			switch tin.kind {
			case Inc:
				tin.kind = Dec
			case Dec:
				tin.kind = Inc
			case Toggle:
				tin.kind = Inc
			case JnzRI:
				tin.kind = CopyRI
			case JnzIR:
				tin.kind = CopyIR
			case JnzII:
				tin.kind = CopyII
			case CopyIR:
				tin.kind = JnzIR
			case CopyRI:
				tin.kind = JnzRI
			case CopyII:
				tin.kind = JnzII
			}
			opt = optimize(p.inst)
		case Add:
			p.reg[in.args[0]] += p.reg[in.args[1]]
			p.reg[in.args[1]] = 0
		case Mul:
			p.reg[in.args[0]] += p.reg[in.args[1]] * p.reg[in.args[2]]
			p.reg[in.args[1]] = 0
			p.reg[in.args[2]] = 0
		case Nop:
			// no op
		default:
			fmt.Printf("%v\n", in)
			panic("invalid instruction")
		}
		p.ip++
	}
	return p.reg[0]
}
