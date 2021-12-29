package elfprog2016

import (
	"fmt"

	aoc "github.com/beanz/advent/lib-go"
)

type InstKind byte

const (
	Copy InstKind = iota
	CopyImmediate
	Inc
	Dec
	Jnz
	JnzImmediate
)

func (ik InstKind) String() string {
	switch ik {
	case Copy:
		return "cpy"
	case CopyImmediate:
		return "cpyi"
	case Inc:
		return "inc"
	case Dec:
		return "dec"
	case Jnz:
		return "jnz"
	case JnzImmediate:
		return "jnzi"
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
			if in[i+4] == 'a' || in[i+4] == 'b' || in[i+4] == 'c' || in[i+4] == 'd' {
				ep.inst = append(ep.inst,
					&Inst{Copy, []int{int(in[i+4] - 'a'), int(in[i+6] - 'a')}})
				i += 8
				break
			}
			v, j := aoc.ScanInt(in, i+4)
			i = j + 1
			ep.inst = append(ep.inst,
				&Inst{CopyImmediate, []int{v, int(in[i] - 'a')}})
			i += 2
		case 'i':
			ep.inst = append(ep.inst, &Inst{Inc, []int{int(in[i+4] - 'a')}})
			i += 6
		case 'd':
			ep.inst = append(ep.inst, &Inst{Dec, []int{int(in[i+4] - 'a')}})
			i += 6
		case 'j':
			if in[i+4] == 'a' || in[i+4] == 'b' || in[i+4] == 'c' || in[i+4] == 'd' {
				v, j := aoc.ScanInt(in, i+6)
				ep.inst = append(ep.inst,
					&Inst{Jnz, []int{int(in[i+4] - 'a'), v}})
				i = j + 1
				break
			}
			v1, j := aoc.ScanInt(in, i+4)
			i = j + 1
			v2, j := aoc.ScanInt(in, i)
			i = j + 1
			ep.inst = append(ep.inst,
				&Inst{JnzImmediate, []int{v1, v2}})
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
		switch in.kind {
		case Inc:
			p.reg[in.args[0]]++
		case Dec:
			p.reg[in.args[0]]--
		case Copy:
			p.reg[in.args[1]] = p.reg[in.args[0]]
		case CopyImmediate:
			p.reg[in.args[1]] = in.args[0]
		case Jnz:
			v := p.reg[in.args[0]]
			if v != 0 {
				p.ip += in.args[1] - 1 // -1 because we add one every iteration
			}
		case JnzImmediate:
			v := in.args[0]
			if v != 0 {
				p.ip += in.args[1] - 1 // -1 because we add one every iteration
			}
		default:
			panic("invalid instruction")
		}
		p.ip++
		// 	p.ip += jmp
		// case "tgl":
		// 	offset := p.regValueOrImmediate(in.args[0])
		// 	offset += p.ip
		// 	if offset < 0 || offset >= len(p.inst) {
		// 		p.ip++
		// 		continue
		// 	}
		// 	tin := p.inst[offset]
		// 	switch tin.kind {
		// 	case "inc":
		// 		tin.kind = "dec"
		// 	case "dec":
		// 		tin.kind = "inc"
		// 	case "tgl":
		// 		tin.kind = "inc"
		// 	case "jnz":
		// 		tin.kind = "cpy"
		// 	case "cpy":
		// 		tin.kind = "jnz"
		// 	}
		// 	p.ip++
		// default:
		// 	fmt.Fprintf(os.Stderr, "Unsupported instruction: %s\n", in)
		// 	p.ip++
		// }
	}
	return p.reg[0]
}
