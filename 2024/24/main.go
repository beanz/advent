package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type (
	Op  int
	Rec struct {
		a, b int
		op   Op
		val  *int
	}
)

const (
	XOR Op = iota
	OR
	AND
)

func Parts(in []byte, args ...int) (int, [31]byte) {
	gates := make(map[int]*Rec, 320)
	rev := make(map[int]int, 256)
	bitCount := 0
	k := func(s []byte) int {
		return (((int(s[0]) << 8) + int(s[1])) << 8) + int(s[2])
	}
	lk := func(g *Rec) int {
		return (((g.a << 24) + g.b) << 2) + int(g.op)
	}
	intPtr := func(i int) *int { return &i }
	for i := 0; i < len(in); {
		if in[i] == '\n' {
			i++
			continue
		}
		if in[i+3] == ':' {
			v := int(in[i+5] - '0')
			gates[k(in[i:i+3])] = &Rec{val: intPtr(v)}
			i += 7
			continue
		}
		var kk int
		switch in[i+4] {
		case 'X': // XOR
			kk = k(in[i+15 : i+18])
			gates[kk] = &Rec{
				a:  k(in[i : i+3]),
				b:  k(in[i+8 : i+11]),
				op: XOR,
			}
			i += 19
		case 'A': // AND
			kk = k(in[i+15 : i+18])
			gates[kk] = &Rec{
				a:  k(in[i : i+3]),
				b:  k(in[i+8 : i+11]),
				op: AND,
			}
			i += 19
		default: // OR
			kk = k(in[i+14 : i+17])
			gates[kk] = &Rec{
				a:  k(in[i : i+3]),
				b:  k(in[i+7 : i+10]),
				op: OR,
			}
			i += 18
		}
		rev[lk(gates[kk])] = kk
		if byte((kk>>16)&0xff) == 'z' {
			n := 10*int(in[i-3]-'0') + int(in[i-2]-'0')
			if bitCount < n {
				bitCount = n
			}
		}
	}
	var value func(s int) int
	value = func(s int) int {
		g := gates[s]
		if g.val == nil {
			va := value(g.a)
			vb := value(g.b)
			var v int
			switch g.op {
			case OR:
				v = va | vb
			case AND:
				v = va & vb
			case XOR:
				v = va ^ vb
			}
			g.val = &v
		}
		return *g.val
	}
	kn := func(ch byte, n int) int {
		return k([]byte{ch, '0' + byte(n/10), '0' + byte(n%10)})
	}
	p1 := 0
	for z := bitCount; z >= 0; z-- {
		p1 <<= 1
		p1 += value(kn('z', z))
	}
	if bitCount < 20 {
		return p1, [31]byte{'t', 'e', 's', 't'}
	}
	gateFor := func(a, b int, op Op) int {
		g := &Rec{a: a, b: b, op: op}
		if v, ok := rev[lk(g)]; ok {
			return v
		}
		g = &Rec{a: b, b: a, op: op}
		return rev[lk(g)]
	}
	bad := make([]int, 0, 8)
	var carry int
	for z := 0; z <= bitCount-2; z++ {
		x := kn('x', z)
		y := kn('y', z)

		xor := gateFor(x, y, XOR) // add
		and := gateFor(x, y, AND) // carry

		if carry == 0 {
			carry = and
			continue
		}

		carryAnd := gateFor(carry, xor, AND)
		if carryAnd == 0 {
			xor, and = and, xor
			bad = append(bad, xor, and)
			carryAnd = gateFor(carry, xor, AND)
		}

		carryXor := gateFor(carry, xor, XOR)
		if byte((xor>>16)&0xff) == 'z' {
			xor, carryXor = carryXor, xor
			bad = append(bad, xor, carryXor)
		}

		if byte((and>>16)&0xff) == 'z' {
			and, carryXor = carryXor, and
			bad = append(bad, and, carryXor)
		}

		if byte((carryAnd>>16)&0xff) == 'z' {
			carryAnd, carryXor = carryXor, carryAnd
			bad = append(bad, carryAnd, carryXor)
		}

		newCarry := gateFor(carryAnd, and, OR)
		if byte((newCarry>>16)&0xff) == 'z' {
			newCarry, carryXor = carryXor, newCarry
			bad = append(bad, newCarry, carryXor)
		}
		carry = newCarry
	}
	sort.Ints(bad)
	p2 := [31]byte{}
	p2[0] = byte((bad[0] >> 16) & 0xff)
	p2[1] = byte((bad[0] >> 8) & 0xff)
	p2[2] = byte(bad[0] & 0xff)
	for i := 1; i < len(bad); i++ {
		j := 3 + (i-1)*4
		p2[j] = ','
		p2[j+1] = byte((bad[i] >> 16) & 0xff)
		p2[j+2] = byte((bad[i] >> 8) & 0xff)
		p2[j+3] = byte(bad[i] & 0xff)
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", string(p2[:]))
	}
}

var benchmark = false
