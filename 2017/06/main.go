package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Mem struct {
	banks []int
	debug bool
}

func NewMem(file string) *Mem {
	line := ReadLines(file)[0]
	return &Mem{ReadInts(strings.Split(line, "\t")), false}
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	mem := NewMem(os.Args[1])
	fmt.Printf("Part 1: %d\n", mem.Part1())
	mem = NewMem(os.Args[1])
	fmt.Printf("Part 2: %d\n", mem.Part2())
}
