package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Scanner struct {
	depth int
	r     int
}

type Firewall struct {
	scanners []Scanner
	debug    bool
}

func NewFirewall(lines []string) *Firewall {
	fw := &Firewall{[]Scanner{}, false}
	for _, line := range lines {
		ints := SimpleReadInts(line)
		fw.scanners = append(fw.scanners, Scanner{ints[0], ints[1]})
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
	fw := NewFirewall(ReadLines(InputFile()))
	fmt.Printf("Part 1: %d\n", fw.Part1())
	fmt.Printf("Part 2: %d\n", fw.Part2())
}
