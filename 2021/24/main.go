package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Constraint struct {
	i, j int
}

type ALU struct {
	addX []int
	addY []int
	divZ []int
	cons []Constraint
}

func nInt(in []byte) int {
	m := 1
	n := 0
	i := 0
	if in[i] == '-' {
		m = -1
		i++
	}
	for ; i < len(in); i++ {
		n = 10*n + int(in[i]-'0')
	}
	return m * n
}

func NewALU(in []byte) *ALU {
	j := 0
	y := 0
	alu := &ALU{make([]int, 0, 14), make([]int, 0, 14), make([]int, 0, 14),
		make([]Constraint, 0, 14),
	}
	for i := 0; i < len(in); i++ {
		if in[i] == '\n' {
			switch in[j] {
			case 'a':
				if in[j+6] < 'w' {
					switch in[j+4] {
					case 'x':
						if in[j+6] < 'w' {
							alu.addX = append(alu.addX, nInt(in[j+6:i]))
						}
					case 'y':
						if (y % 3) == 2 {
							alu.addY = append(alu.addY, nInt(in[j+6:i]))
						}
						y++
					}
				}
			case 'd':
				if in[j+4] == 'z' {
					alu.divZ = append(alu.divZ, nInt(in[j+6:i]))
				}
			}
			j = i + 1
		}
	}
	if len(alu.addX) != 14 {
		panic("wrong number of add x found")
	}
	if len(alu.addY) != 14 {
		panic("wrong number of add Y found")
	}
	if len(alu.divZ) != 14 {
		panic("wrong number of div Z found")
	}
	stack := make([]int, 0, 14)
	for i := 0; i < 14; i++ {
		if alu.divZ[i] != 1 {
			j, stack = stack[len(stack)-1], stack[:len(stack)-1]
			alu.cons = append(alu.cons, Constraint{i, j})
		} else {
			stack = append(stack, i)
		}
	}
	return alu
}

func (a *ALU) Solve(start, inc int) int {
	ans := make([]int, 14)
	for i := 0; i < 14; i++ {
		ans[i] = start
	}
	for _, c := range a.cons {
		for {
			ans[c.i] = ans[c.j] + a.addY[c.j] + a.addX[c.i]
			if 0 < ans[c.i] && ans[c.i] <= 9 {
				break
			}
			ans[c.j] += inc
		}
	}
	n := 0
	for i := 0; i < 14; i++ {
		n = n*10 + int(ans[i])
	}
	return n
}

func (a *ALU) Parts() (int, int) {
	p1 := a.Solve(9, -1)
	p2 := a.Solve(1, 1)
	return p1, p2
}

func main() {
	g := NewALU(InputBytes(input))
	p1, p2 := g.Parts()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
