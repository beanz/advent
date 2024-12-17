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
	i += 39
	expect := in[i : len(in)-1]
	prog := make([]int, 0, 30)
	for ; i < len(in); i += 2 {
		prog = append(prog, int(in[i]-'0'))
	}
	out1 := [32]byte{}
	p1 := run(prog, a, out1[:0])
	out := [32]byte{}
	p2 := 0
	todo := [][2]int{{1, 0}}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		for c := 0; c < 8; c++ {
			v := c + 8*cur[1]
			got := run(prog, v, out[:0])
			if comp(expect, got, cur[0]) {
				if cur[0] == len(prog) {
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

func run(prog []int, a int, out []byte) []byte {
	out = out[:0]
	var b, c int
	ip := 0
	for ip < len(prog)-1 {
		op := prog[ip]
		literal := prog[ip+1]
		var combo int
		switch literal {
		case 0, 1, 2, 3:
			combo = literal
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
				ip = literal
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
		ip += 2
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
