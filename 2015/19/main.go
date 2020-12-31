package main

import (
	"fmt"
	"math/rand"
	"strings"

	. "github.com/beanz/advent2015/lib"
)

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
	return &Mach{init: in[1][:len(in[1])-1], rules: r}
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

type Search struct {
	s string
	c int
}

func (m *Mach) Part2() int {
	for {
		s := m.init
		c := 0
		p := ""
		for p != s {
			p = s
			for _, rule := range m.rules {
				n := strings.Count(s, rule.replace)
				if n == 0 {
					continue
				}
				c += n
				s = strings.Replace(s, rule.replace, rule.find, -1)
				if s == "e" {
					return c
				}
			}
		}
		// try different order
		for i := range m.rules {
			j := rand.Intn(i + 1)
			m.rules[i], m.rules[j] = m.rules[j], m.rules[i]
		}
	}
	return -1
}

func main() {
	s := ReadInputChunks()
	m := NewMach(s)
	fmt.Printf("Part 1: %d\n", m.Part1())
	fmt.Printf("Part 2: %d\n", m.Part2())
}
