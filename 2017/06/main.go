package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Mem struct {
	banks []int
	debug bool
}

func NewMem(inp []int) *Mem {
	return &Mem{inp, false}
}

func (m *Mem) State() string {
	s := []string{}
	for _, b := range m.banks {
		s = append(s, fmt.Sprintf("%d", b))
	}
	return strings.Join(s, " ")
}

func (m *Mem) Run() (int, int) {
	cycles := 0
	seen := map[string]int{}
	for {
		state := m.State()
		if seen[state] != 0 {
			return cycles, seen[state]
		}
		seen[state] = cycles
		max := 0
		maxi := -1
		for i, b := range m.banks {
			if b > max {
				max = b
				maxi = i
			}
		}
		blocks := m.banks[maxi]
		m.banks[maxi] = 0
		for i := 1; i <= blocks; i++ {
			m.banks[(maxi+i)%len(m.banks)]++
		}
		cycles++
	}
}

func (m *Mem) Part1() int {
	cycles, _ := m.Run()
	return cycles
}

func (m *Mem) Part2() int {
	cycles, first := m.Run()
	return cycles - first
}

func main() {
	mem := NewMem(InputInts(input))
	p1 := mem.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	mem = NewMem(InputInts(input))
	p2 := mem.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
