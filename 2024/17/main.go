package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (string, int) {
	i, a := ChompUInt[int](in, 12)
	prog := in[i+39 : len(in)-1]
	out1 := [32]byte{}
	p1 := run(prog, a, out1[:0])
	out := [32]byte{}
	p2 := 0
	l := (len(prog) + 1) / 2
	todo := [][2]int{{1, 0}}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		for c := 0; c < 8; c++ {
			v := c + 8*cur[1]
			got := run(prog, v, out[:0])
			if comp(prog, got, cur[0]) {
				if cur[0] == l {
					p2 = v
					todo = todo[:0]
					break
				}
				todo = append(todo, [2]int{cur[0] + 1, v})
			}
		}
	}
	return string(p1), p2
}

func comp(exp []byte, got []byte, i int) bool {
	if len(got) < i*2-1 {
		return false
	}
	for j := i; j > 0; j -= 1 {
		k := j*2 - 1
		if exp[len(exp)-k] != got[len(got)-k] {
			return false
		}
	}
	return true
}

func run(prog []byte, a int, out []byte) []byte {
	if len(prog) != 31 {
		return runSlow(prog, a, out)
	}
	x := int(prog[6] - '0')
	var y int
	if prog[12] == '1' {
		y = int(prog[14] - '0')
	} else {
		y = int(prog[18] - '0')
	}
	out = out[:0]
	var b, c int
	for a > 0 {
		b = a & 7
		b ^= x
		c = a >> b
		b ^= y
		b ^= c
		a >>= 3
		if len(out) == 0 {
			out = append(out, byte(b&7+'0'))
		} else {
			out = append(out, ',', byte(b&7+'0'))
		}
	}
	return out
}

func runSlow(prog []byte, a int, out []byte) []byte {
	out = out[:0]
	var b, c int
	ip := 0
	for ip < len(prog)-2 {
		op := prog[ip] - '0'
		literal := int(prog[ip+2] - '0')
		var combo int
		switch literal {
		case 0, 1, 2, 3:
			combo = int(literal)
		case 4:
			combo = a
		case 5:
			combo = b
		case 6:
			combo = c
		}
		switch op {
		case 0:
			a = a >> combo
		case 1:
			b ^= literal
		case 2:
			b = combo & 7
		case 3:
			if a != 0 {
				ip = literal * 2
				continue
			}
		case 4:
			b ^= c
		case 5:
			if len(out) == 0 {
				out = append(out, byte(combo&7+'0'))
			} else {
				out = append(out, ',', byte(combo&7+'0'))
			}
		case 6:
			b = a >> combo
		default:
			c = a >> combo
		}
		ip += 4
	}
	return out
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %s\n", string(p1))
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
