package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	chunks := ReadChunks(os.Args[1])
	dec := NewDec(chunks)
	fmt.Printf("Part 1: %d\n", dec.Part1())
	fmt.Printf("Part 2: %d\n", dec.Part2())
}
