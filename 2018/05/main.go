package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	m     string
	debug bool
}

func NewGame(lines []string) *Game {
	return &Game{lines[0], false}
}

func react(m string) string {
	old := ""
	for old != m {
		old = m
		for _, e := range []string{"aA", "Aa", "bB", "Bb", "cC", "Cc",
			"dD", "Dd", "eE", "Ee", "fF", "Ff", "gG", "Gg", "hH", "Hh",
			"iI", "Ii", "jJ", "Jj", "kK", "Kk", "lL", "Ll", "mM", "Mm",
			"nN", "Nn", "oO", "Oo", "pP", "Pp", "qQ", "Qq", "rR", "Rr",
			"sS", "Ss", "tT", "Tt", "uU", "Uu", "vV", "Vv", "wW", "Ww",
			"xX", "Xx", "yY", "Yy", "zZ", "Zz"} {
			m = strings.Replace(m, e, "", -1)
		}
	}
	return m

}

func (g *Game) Part1() int {
	return len(react(g.m))
}

func (g *Game) Part2() int {
	m := react(g.m)
	min := len(m)
	for _, l := range []string{"a", "b", "c", "d", "e", "f", "g", "h",
		"i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
		"v", "w", "x", "y", "z"} {
		n := len(react(strings.Replace(strings.Replace(m, l, "", -1),
			strings.ToUpper(l), "", -1)))
		if n < min {
			min = n
		}
	}
	return min
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
