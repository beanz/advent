package main

import (
	_ "embed"
	"fmt"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type (
	Op  int
	Rec struct {
		a, b string
		op   Op
	}
)

const (
	XOR Op = iota
	OR
	AND
)

func Parts(in []byte, args ...int) (int, string) {
	x := [45]bool{}
	y := [45]bool{}
	gates := map[string]Rec{}
	rev := map[string]string{}
	bitCount := 0
	for i := 0; i < len(in); {
		if in[i] == '\n' {
			i++
			continue
		}
		if in[i+3] == ':' {
			n := 10*int(in[i+1]-'0') + int(in[i+2]-'0')
			v := in[i+5] == '1'
			if in[i] == 'x' {
				x[n] = v
			} else {
				y[n] = v
			}
			i += 7
			continue
		}
		var k string
		switch in[i+4] {
		case 'X': // XOR
			k = string(in[i+15 : i+18])
			gates[k] = Rec{
				a:  string(in[i : i+3]),
				b:  string(in[i+8 : i+11]),
				op: XOR,
			}
			rev[string(in[i:i+11])] = k
			i += 19
		case 'A': // AND
			k = string(in[i+15 : i+18])
			gates[k] = Rec{
				a:  string(in[i : i+3]),
				b:  string(in[i+8 : i+11]),
				op: AND,
			}
			rev[string(in[i:i+11])] = k
			i += 19
		default: // OR
			k = string(in[i+14 : i+17])
			gates[k] = Rec{
				a:  string(in[i : i+3]),
				b:  string(in[i+7 : i+10]),
				op: OR,
			}
			rev[string(in[i:i+10])] = k
			i += 18
		}
		if k[0] == 'z' {
			n := 10*int(in[i-3]-'0') + int(in[i-2]-'0')
			if bitCount < n {
				bitCount = n
			}
		}
	}
	var value func(s string) bool
	value = func(s string) bool {
		if g, ok := gates[s]; ok {
			va := value(g.a)
			vb := value(g.b)
			switch g.op {
			case OR:
				return va || vb
			case AND:
				return va && vb
			case XOR:
				return va != vb
			}
		}
		n := 10*int(s[1]-'0') + int(s[2]-'0')
		if s[0] == 'x' {
			return x[n]
		}
		return y[n]
	}
	p1 := 0
	for z := bitCount; z >= 0; z-- {
		p1 <<= 1
		if value(fmt.Sprintf("z%02d", z)) {
			p1++
		}
	}
	if bitCount < 20 {
		return p1, "test"
	}
	gateFor := func(k string) string {
		if v, ok := rev[k]; ok {
			return v
		}
		f := k[0:3]
		m := k[3 : len(k)-3]
		l := k[len(k)-3:]
		return rev[l+m+f]
	}
	bad := []string{}
	var carry string
	for z := 0; z <= bitCount-2; z++ {
		x := fmt.Sprintf("x%02d", z)
		y := fmt.Sprintf("y%02d", z)

		xor := gateFor(x + " XOR " + y) // add
		and := gateFor(x + " AND " + y) // carry

		if carry == "" {
			carry = and
			continue
		}

		carryAnd := gateFor(carry + " AND " + xor)
		if carryAnd == "" {
			xor, and = and, xor
			bad = append(bad, xor, and)
			carryAnd = gateFor(carry + " AND " + xor)
		}

		carryXor := gateFor(carry + " XOR " + xor)
		if len(xor) > 0 && xor[0] == 'z' {
			xor, carryXor = carryXor, xor
			bad = append(bad, xor, carryXor)
		}

		if len(and) > 0 && and[0] == 'z' {
			and, carryXor = carryXor, and
			bad = append(bad, and, carryXor)
		}

		if len(carryAnd) > 0 && carryAnd[0] == 'z' {
			carryAnd, carryXor = carryXor, carryAnd
			bad = append(bad, carryAnd, carryXor)
		}

		newCarry := gateFor(carryAnd + " OR " + and)
		if newCarry[0] == 'z' {
			newCarry, carryXor = carryXor, newCarry
			bad = append(bad, newCarry, carryXor)
		}
		carry = newCarry
	}
	sort.Strings(bad)
	return p1, strings.Join(bad, ",")
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
