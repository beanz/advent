package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Scanner struct {
	depth int
	r     int
}

type Firewall struct {
	scanners []Scanner
	debug    bool
}

func NewFirewall(inp []byte) *Firewall {
	fw := &Firewall{[]Scanner{}, false}
	ints := FastInts(inp, 128)
	for i := 0; i < len(ints); i += 2 {
		fw.scanners = append(fw.scanners, Scanner{ints[i], ints[i+1]})
	}
	return fw
}

func (fw *Firewall) Run(delay int) (int, bool) {
	sev := 0
	caught := false
	for _, s := range fw.scanners {
		if (delay+s.depth)%((s.r-1)*2) == 0 {
			if fw.debug {
				fmt.Printf("hit at depth %d\n", s.depth)
			}
			sev += s.depth * s.r
			caught = true
		}
	}
	return sev, caught
}

func (fw *Firewall) Part1() int {
	sev, _ := fw.Run(0)
	return sev
}

func (fw *Firewall) Part2() int {
	for delay := 0; ; delay++ {
		_, caught := fw.Run(delay)
		if !caught {
			return delay
		}
	}
}

func main() {
	fw := NewFirewall(InputBytes(input))
	p1 := fw.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := fw.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
