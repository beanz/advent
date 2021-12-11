package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Wiring map[string]interface{}

func Find(w Wiring, ch string) int {
	if ch[0] >= '0' && ch[0] <= '9' {
		return MustParseInt(ch)
	}
	s := w[ch]
	switch t := s.(type) {
	case int:
		return t
	case string:
		lhs := strings.Split(t, " ")
		var res int
		switch len(lhs) {
		case 1:
			res = Find(w, lhs[0])
		case 2:
			if lhs[0] == "NOT" {
				res = 0xFFFF ^ Find(w, lhs[1])
			} else {
				panic("Invalid lhs: " + t)
			}
		case 3:
			switch lhs[1] {
			case "AND":
				res = Find(w, lhs[0]) & Find(w, lhs[2])
			case "OR":
				res = Find(w, lhs[0]) | Find(w, lhs[2])
			case "LSHIFT":
				res = (Find(w, lhs[0]) << MustParseInt(lhs[2])) & 0xffff
			case "RSHIFT":
				res = Find(w, lhs[0]) >> MustParseInt(lhs[2])
			default:
				panic("Invalid lhs: " + t)
			}
		}
		w[ch] = res
		return res
	}
	//fmt.Printf("%s <= %s\n", ch, s)
	return 0
}

func Part1(in []string, ch string) int {
	w := make(Wiring, len(in))
	for _, l := range in {
		ss := strings.Split(l, " -> ")
		w[ss[1]] = ss[0]
	}
	return Find(w, ch)
}

func Part2(in []string, ch string, p1 int) int {
	w := make(Wiring, len(in))
	for _, l := range in {
		ss := strings.Split(l, " -> ")
		w[ss[1]] = ss[0]
	}
	w["b"] = p1
	return Find(w, ch)
}

func main() {
	in := InputLines(input)
	p1 := Part1(in, "a")
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(in, "a", p1)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
