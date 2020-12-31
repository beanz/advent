package main

import (
	"fmt"
	"strings"

	. "github.com/beanz/advent2015/lib"
)

func ReadSpec() map[string]int {
	tape := ReadFileLines("tape.txt")
	spec := make(map[string]int, len(tape))
	for _, l := range tape {
		s := strings.Split(l, ": ")
		spec[s[0]] = MustParseInt(s[1])
	}
	return spec
}

type Sue map[string]int

func NewSue(s string) map[string]int {
	ss := strings.SplitN(s, " ", 3)
	num := MustParseInt(ss[1][:len(ss[1])-1])
	ss = strings.Split(ss[2], ", ")
	sue := make(map[string]int, len(ss)+1)
	for _, prop := range ss {
		ps := strings.Split(prop, ": ")
		sue[ps[0]] = MustParseInt(ps[1])
	}
	sue["num"] = num
	return sue
}
func (s Sue) Num() int {
	return s["num"]
}

type Sues []Sue

func NewSues(in []string) Sues {
	sues := make([]Sue, len(in))
	for i, l := range in {
		sues[i] = NewSue(l)
	}
	return sues
}

func (s Sues) Part1() int {
	spec := ReadSpec()
	for _, s := range s {
		valid := true
		for req, num := range spec {
			if _, ok := s[req]; !ok {
				continue
			}
			if s[req] != num {
				valid = false
				break
			}
		}
		if valid {
			return s.Num()
		}
	}
	return -1
}

func (s Sues) Part2() int {
	spec := ReadSpec()
	for _, s := range s {
		valid := true
		for req, num := range spec {
			if _, ok := s[req]; !ok {
				continue
			}
			switch req {
			case "cats", "trees":
				if s[req] <= num {
					valid = false
					break
				}
			case "pomeranians", "goldfish":
				if s[req] >= num {
					valid = false
					break
				}
			default:
				if s[req] != num {
					valid = false
					break
				}
			}
		}
		if valid {
			return s.Num()
		}
	}
	return -2
}

func main() {
	sues := NewSues(ReadInputLines())
	fmt.Printf("Part 1: %d\n", sues.Part1())
	fmt.Printf("Part 2: %d\n", sues.Part2())
}
