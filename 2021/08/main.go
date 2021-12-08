package main

import (
	"fmt"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type StringPerm struct {
	s string
}

func (sp *StringPerm) Permute(s string) string {
	r := ""
	for _, ch := range s {
		r += string(sp.s[byte(ch)-byte('a')])
	}
	return r
}
func Factorial(n int) int {
	res := 1
	for i := 2; i <= n; i++ {
		res *= i
	}
	return res
}

func join(pre []byte, c byte) []StringPerm {
	res := []StringPerm{}
	for i := 0; i <= len(pre); i++ {
		res = append(res,
			StringPerm{string(pre[:i]) + string(c) + string(pre[i:])})
	}
	return res
}

func StringPerms(s string) []StringPerm {
	// TODO fix this
	// res := make([]StringPerm, 0, Factorial(len(s)))
	// perms := NewPerms(len(s))
	// for perm := perms.Get(); !perms.Done(); perm = perms.Next() {
	// 	s := ""
	// 	for _, v := range perm {
	// 		s += string('a' + byte(v))
	// 	}
	// 	fmt.Println(s)
	// 	res = append(res, StringPerm{s})
	// }
	var aux func([]byte, []StringPerm) []StringPerm
	aux = func(s []byte, p []StringPerm) []StringPerm {
		if len(s) == 0 {
			return p
		}
		res := []StringPerm{}
		for _, v := range p {
			res = append(res, join([]byte(v.s), s[0])...)
		}
		return aux(s[1:], res)
	}
	res := []byte(s)
	return aux(res[1:], []StringPerm{StringPerm{string(s[0])}})
}

func CanonicalDigit(w string) string {
	s := strings.Split(w, "")
	sort.Strings(s)
	return strings.Join(s, "")
}

func Digit(w string) int {
	switch CanonicalDigit(w) {
	case "abcefg":
		return 0
	case "cf":
		return 1
	case "acdeg":
		return 2
	case "acdfg":
		return 3
	case "bcdf":
		return 4
	case "abdfg":
		return 5
	case "abdefg":
		return 6
	case "acf":
		return 7
	case "abcdefg":
		return 8
	case "abcdfg":
		return 9
	default:
		return -1
	}
}

type Entry struct {
	pattern []string
	output  []string
}

type Notes struct {
	entries []Entry
	debug   bool
}

func NewNotes(in []string) *Notes {
	entries := make([]Entry, 0, len(in))
	for _, l := range in {
		s := strings.Split(l, " | ")
		p := strings.Split(s[0], " ")
		o := strings.Split(s[1], " ")
		entries = append(entries, Entry{pattern: p, output: o})
	}
	return &Notes{entries, false}
}

func (n *Notes) Part1() int {
	c := 0
	for _, e := range n.entries {
		for _, o := range e.output {
			if len(o) == 2 || len(o) == 3 || len(o) == 4 || len(o) == 7 {
				c++
			}
		}
	}
	return c
}

func (n *Notes) Part2() int {
	perms := StringPerms("abcdefg")
	c := 0
ENTRY:
	for _, e := range n.entries {
	PERM:
		for _, p := range perms {
			for _, w := range e.pattern {
				if Digit(p.Permute(w)) == -1 {
					continue PERM
				}
			}
			n := 0
			for _, w := range e.output {
				d := Digit(p.Permute(w))
				if d == -1 {
					panic(p.s + ": " + w)
				}
				n = n*10 + d
			}
			c += n
			continue ENTRY
		}
	}
	return c
}

func main() {
	inp := ReadInputLines()
	n := NewNotes(inp)
	fmt.Printf("Part 1: %d\n", n.Part1())
	fmt.Printf("Part 2: %d\n", n.Part2())
}
