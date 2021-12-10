package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Ans []string

type Dec struct {
	entries []Ans
	debug   bool
}

func NewDec(chunks []string) *Dec {
	var res []Ans
	for _, ch := range chunks {
		var ans Ans
		for _, l := range strings.Split(ch, "\n") {
			ans = append(ans, l)
		}
		res = append(res, strings.Split(ch, "\n"))
	}
	return &Dec{res, false}
}

func (d *Dec) Part1() int {
	c := 0
	for _, e := range d.entries {
		m := make(map[rune]int, 100)
		for _, l := range e {
			for _, ch := range l {
				m[ch]++
			}
		}
		c += len(m)
	}
	return c
}

func (d *Dec) Part2() int {
	c := 0
	for _, e := range d.entries {
		m := make(map[rune]int, 100)
		for _, l := range e {
			for _, ch := range l {
				m[ch]++
			}
		}
		for _, v := range m {
			if v == len(e) {
				c++
			}
		}
	}
	return c
}

func main() {
	chunks := InputChunks(input)
	dec := NewDec(chunks)
	p1 := dec.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := dec.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
