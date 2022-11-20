package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Rule struct {
	find    string
	replace string
}

type Rules []Rule

type Mach struct {
	rules Rules
	init  string
}

func NewMach(in []string) *Mach {
	ruleLines := strings.Split(in[0], "\n")
	r := Rules{}
	for _, l := range ruleLines {
		sl := strings.Split(l, " => ")
		r = append(r, Rule{find: sl[0], replace: sl[1]})
	}
	init := strings.TrimSuffix(in[1], "\n")
	return &Mach{init: init, rules: r}
}

func (m *Mach) Part1() int {
	s := m.init
	res := make(map[string]bool)
	for i := 0; i < len(s); i++ {
		for _, rule := range m.rules {
			if i+len(rule.find) > len(s) {
				continue
			}
			if s[i:i+len(rule.find)] != rule.find {
				continue
			}
			n := s[:i] + rule.replace + s[i+len(rule.find):]
			res[n] = true
		}
	}
	return len(res)
}

func (m *Mach) Part2() int {
	upperCount := 0
	yCount := 0
	for _, r := range m.init {
		if r < 'a' {
			upperCount++
		}
		if r == 'Y' {
			yCount++
		}
	}
	rnCount := strings.Count(m.init, "Rn")
	arCount := strings.Count(m.init, "Ar")
	return upperCount - rnCount - arCount - 2*yCount - 1
}

func main() {
	s := InputChunks(input)
	m := NewMach(s)
	p1 := m.Part1()
	p2 := m.Part2()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
