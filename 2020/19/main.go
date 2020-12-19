package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Rule struct {
	ch string
	or [][]int
}

func (r Rule) String() string {
	if r.ch == "" {
		return fmt.Sprintf("%v", r.or)
	}
	return r.ch
}

type Matcher struct {
	rules  map[int]Rule
	values []string
	debug  bool
}

func NewMatcher(in []string) *Matcher {
	rs := strings.Split(in[0], "\n")
	r := make(map[int]Rule, len(rs))
	for _, l := range rs {
		s := strings.Split(l, ": ")
		n, err := strconv.Atoi(s[0])
		if err != nil {
			log.Fatalf("invalid rule %s\n", l)
		}
		if s[1][0] == '"' {
			r[n] = Rule{ch: string(s[1][1])}
		} else {
			os := strings.Split(s[1], " | ")
			or := make([][]int, len(os))
			for i := 0; i < len(os); i++ {
				opt := SimpleReadInts(os[i])
				or[i] = opt
			}
			r[n] = Rule{or: or}
		}
	}
	return &Matcher{r, strings.Split(in[1], "\n"), true}
}

func (m *Matcher) String() string {
	s := ""
	for k, v := range m.rules {
		s += fmt.Sprintf("R[%d]: %s\n", k, v)
	}
	for _, v := range m.values {
		s += fmt.Sprintf("V: %s\n", v)
	}
	return s
}

func (m *Matcher) Regexp(i int) string {
	r := m.rules[i]
	if r.ch != "" {
		// ch rule
		return string(r.ch)
	}

	// or rule
	res := "(?:"
	os := make([]string, len(r.or))
	for i, o := range r.or {
		s := ""
		for _, rn := range o {
			s += m.Regexp(rn)
		}
		os[i] = s
	}
	res += strings.Join(os, "|")
	res += ")"
	return res
}

func (m *Matcher) Part1() int {
	//fmt.Printf("%s\n", m)
	re := "^" + m.Regexp(0) + "$"
	//fmt.Printf("RE[0]: %s\n", re)
	c := 0
	cre := regexp.MustCompile(re)
	for _, v := range m.values {
		if cre.MatchString(v) {
			//fmt.Printf("%s matched\n", v)
			c++
		}
	}
	return c
}

func (m *Matcher) Part2() int {
	re31 := m.Regexp(31)
	re42 := m.Regexp(42)
	m.rules[8] = Rule{ch: re42 + "+"}
	maxRepeats := 5
	ns := make([]string, maxRepeats)
	for i := 0; i < maxRepeats; i++ {
		n := fmt.Sprintf("{%d}", i+1)
		ns[i] = re42 + n + re31 + n
	}
	m.rules[11] = Rule{ch: "(?:" + strings.Join(ns, "|") + ")"}
	re := "^" + m.Regexp(0) + "$"
	//fmt.Printf("RE[0]: %s\n", re)
	c := 0
	cre := regexp.MustCompile(re)
	for _, v := range m.values {
		if cre.MatchString(v) {
			//fmt.Printf("%s matched\n", v)
			c++
		}
	}
	return c
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	chunks := ReadChunks(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewMatcher(chunks).Part1())
	fmt.Printf("Part 2: %d\n", NewMatcher(chunks).Part2())
}
