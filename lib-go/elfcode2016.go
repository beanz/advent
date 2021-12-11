package aoc

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type inst struct {
	kind string
	args []string
}

func (i *inst) String() string {
	return fmt.Sprintf("%s %v", i.kind, i.args)
}

type ElfProg2016 struct {
	inst  []*inst
	ip    int
	Reg   map[string]int
	debug bool
}

func (p *ElfProg2016) String() string {
	s := ""
	for _, r := range []string{"a", "b", "c", "d"} {
		s += fmt.Sprintf("%d ", p.Reg[r])
	}
	s += fmt.Sprintf("%d: %s", p.ip, p.inst[p.ip])
	return s
}

func ReadElfProg2016(lines []string) *ElfProg2016 {
	g := &ElfProg2016{[]*inst{}, 0, map[string]int{}, false}
	g.Reg["a"] = 0
	g.Reg["b"] = 0
	g.Reg["c"] = 0
	g.Reg["d"] = 0
	instRe := regexp.MustCompile(`^(inc|dec|jnz|cpy|tgl)\s+(.*)$`)
	for _, l := range lines {
		m := instRe.FindStringSubmatch(l)
		if m == nil {
			log.Fatalf("Invalid instruction: %s\n", l)
		}
		g.inst = append(g.inst, &inst{m[1], strings.Split(m[2], " ")})
	}
	return g
}

func (p *ElfProg2016) regValueOrImmediate(s string) int {
	if s == "a" || s == "b" || s == "c" || s == "d" {
		return p.Reg[s]
	}
	val, _ := strconv.Atoi(s)
	return val
}

func (p *ElfProg2016) Run() int {
	p.ip = 0
	for p.ip < len(p.inst) {
		if p.debug {
			fmt.Printf("%s\n", p)
		}
		in := p.inst[p.ip]
		switch in.kind {
		case "inc":
			p.Reg[in.args[0]]++
			p.ip++
		case "dec":
			p.Reg[in.args[0]]--
			p.ip++
		case "cpy":
			p.Reg[in.args[1]] = p.regValueOrImmediate(in.args[0])
			p.ip++
		case "jnz":
			val := p.regValueOrImmediate(in.args[0])
			jmp := 1
			if val != 0 {
				jmp = p.regValueOrImmediate(in.args[1])
			}
			p.ip += jmp
		case "tgl":
			offset := p.regValueOrImmediate(in.args[0])
			offset += p.ip
			if offset < 0 || offset >= len(p.inst) {
				p.ip++
				continue
			}
			tin := p.inst[offset]
			switch tin.kind {
			case "inc":
				tin.kind = "dec"
			case "dec":
				tin.kind = "inc"
			case "tgl":
				tin.kind = "inc"
			case "jnz":
				tin.kind = "cpy"
			case "cpy":
				tin.kind = "jnz"
			}
			p.ip++
		default:
			fmt.Fprintf(os.Stderr, "Unsupported instruction: %s\n", in)
			p.ip++
		}
	}
	return p.Reg["a"]
}
