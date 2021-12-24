package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type ALU struct {
	addX  []int
	addY  []int
	divZ  []int
	cache map[int]int
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
		make(map[int]int, 2097152),
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
	return alu
}

func (a *ALU) Calc(zi int, level int, order []int, ans int) int {
	k := (zi << 4) + level
	if v, ok := a.cache[k]; ok {
		return v
	}
	for _, w := range order {
		z := zi / a.divZ[level]
		if (zi % 26) + a.addX[level] != w {
			z *= 26
			z += (w + a.addY[level])
		}
		if level != 13 {
			r := a.Calc(z, level+1, order, ans*10+w)
			a.cache[k] = r
			if r != 0 {
				return r
			}
		} else if z == 0 {
			a.cache[k] = ans*10 + w
			return ans*10 + w
		}
	}
	a.cache[k] = 0
	return 0
}

func (a *ALU) Best(order []int) int {
	return a.Calc(0, 0, order, 0)
}

func (a *ALU) Solve() (int, int) {
	p1 := a.Best([]int{9, 8, 7, 6, 5, 4, 3, 2, 1})
	a.cache =make(map[int]int, 16777216)
	p2 := a.Best([]int{1, 2, 3, 4, 5, 6, 7, 8, 9})
	return p1, p2
}

func main() {
	g := NewALU(InputBytes(input))
	p1, p2 := g.Solve()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
