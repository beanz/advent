package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Stream struct {
	s     string
	i     int
	level int
	debug bool
}

func NewStream(file string) *Stream {
	return &Stream{ReadLines(file)[0], 0, 1, false}
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
	fmt.Printf("Part 1: %d\n", NewStream(InputFile()).Part1())
	fmt.Printf("Part 2: %d\n", NewStream(InputFile()).Part2())
}
