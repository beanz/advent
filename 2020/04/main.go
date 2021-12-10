package main

import (
	_ "embed"
	"fmt"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Passport map[string]string

type Scanner struct {
	entries []Passport
	debug   bool
}

func NewScanner(chunks []string) *Scanner {
	var res []Passport
	for _, ch := range chunks {
		ent := make(map[string]string, 8)
		for _, l := range strings.Split(ch, "\n") {
			if len(l) == 0 {
				continue
			}
			for _, f := range strings.Split(l, " ") {
				kv := strings.Split(f, ":")
				ent[kv[0]] = kv[1]
			}
		}
		res = append(res, ent)
	}
	return &Scanner{res, false}
}

func (pp Passport) String() string {
	st := ""
	for k, v := range pp {
		st += fmt.Sprintf("%s=%s ", k, v)
	}
	return st
}

func (s *Scanner) Part1() int {
	c := 0
PP:
	for _, pp := range s.entries {
		for _, f := range []string{"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"} {
			if _, ok := pp[f]; !ok {
				continue PP
			}
		}
		c++
	}
	return c
}

func validYear(v string, min, max int) bool {
	if len(v) != 4 {
		return false
	}
	y, err := strconv.Atoi(v)
	if err != nil {
		return false
	}
	if y < min || y > max {
		return false
	}
	return true
}

func validHeight(v string) bool {
	l := len(v)
	if l < 3 {
		return false
	}
	units := v[l-2:]
	n, err := strconv.Atoi(v[:l-2])
	if err != nil {
		return false
	}
	if units == "cm" {
		if n < 150 || n > 193 {
			return false
		}
	} else if units == "in" {
		if n < 59 || n > 76 {
			return false
		}
	} else {
		return false
	}
	return true
}

func validEyeColor(v string) bool {
	if v != "amb" && v != "blu" && v != "brn" && v != "gry" &&
		v != "grn" && v != "hzl" && v != "oth" {
		return false
	}
	return true
}

func validPID(v string) bool {
	if len(v) != 9 {
		return false
	}
	_, err := strconv.Atoi(v)
	if err != nil {
		return false
	}
	return true
}

func validHairColor(v string) bool {
	if len(v) != 7 {
		return false
	}
	for _, ch := range v[1:] {
		if !(ch >= 'a' && ch <= 'f') && !(ch >= '0' && ch <= '9') {
			return false
		}
	}
	return true
}

func (s *Scanner) Part2() int {
	c := 0
	for _, pp := range s.entries {
		if v, ok := pp["byr"]; !ok || !validYear(v, 1920, 2002) {
			//fmt.Fprintf(os.Stderr, "Invalid byr: %s\n", v)
			continue
		}
		if v, ok := pp["iyr"]; !ok || !validYear(v, 2010, 2020) {
			//fmt.Fprintf(os.Stderr, "Invalid iyr: %s\n", v)
			continue
		}
		if v, ok := pp["eyr"]; !ok || !validYear(v, 2020, 2030) {
			//fmt.Fprintf(os.Stderr, "Invalid eyr: %s\n", v)
			continue
		}
		if v, ok := pp["hgt"]; !ok || !validHeight(v) {
			//fmt.Fprintf(os.Stderr, "Invalid hgt: %s\n", v)
			continue
		}
		if v, ok := pp["hcl"]; !ok || !validHairColor(v) {
			//fmt.Fprintf(os.Stderr, "Invalid hcl: %s\n", v)
			continue
		}
		if v, ok := pp["ecl"]; !ok || !validEyeColor(v) {
			//fmt.Fprintf(os.Stderr, "Invalid ecl: %s\n", v)
			continue
		}
		if v, ok := pp["pid"]; !ok || !validPID(v) {
			//fmt.Fprintf(os.Stderr, "Invalid pid: %s\n", v)
			continue
		}
		c++
	}
	return c
}

func main() {
	chunks := InputChunks(input)
	scanner := NewScanner(chunks)
	p1 := scanner.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := scanner.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
