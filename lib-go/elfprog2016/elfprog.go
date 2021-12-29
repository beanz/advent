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

func (p *ElfProg) Run() int {
	p.ip = 0
	for p.ip < len(p.inst) {
		in := p.inst[p.ip]
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
		default:
			panic("invalid instruction")
		}
		p.ip++
		// 	p.ip++
		// default:
		// 	fmt.Fprintf(os.Stderr, "Unsupported instruction: %s\n", in)
		// 	p.ip++
		// }
	}
	return p.reg[0]
}
