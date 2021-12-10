package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Stream struct {
	s     string
	i     int
	level int
	debug bool
}

func NewStream(inp []string) *Stream {
	return &Stream{inp[0], 0, 1, false}
}

func (s *Stream) Parse() (int, int) {
	score := 0
	gc := 0
	for i := 0; i < len(s.s); {
		switch s.s[i] {
		case '<':
			i++
			for s.s[i] != '>' {
				if s.s[i] == '!' {
					i++
					gc--
				}
				i++
				gc++
			}
		case '{':
			score += s.level
			s.level++
		case '}':
			s.level--
		}
		i++
	}
	return score, gc
}

func (s *Stream) Part1() int {
	score, _ := s.Parse()
	return score
}

func (s *Stream) Part2() int {
	_, gc := s.Parse()
	return gc
}

func main() {
	p1 := NewStream(InputLines(input)).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewStream(InputLines(input)).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
