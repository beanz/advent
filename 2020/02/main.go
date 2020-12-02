package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"

	. "github.com/beanz/advent-of-code-go"
)

type Ent struct {
	i1, i2 int
	ch     byte
	pw     string
}

type DB struct {
	entries []*Ent
	debug   bool
}

func NewDB(lines []string) *DB {
	lineRe := regexp.MustCompile(`^(\d+)-(\d+) (.): (\w+)$`)
	var ent []*Ent
	for _, line := range lines {
		m := lineRe.FindStringSubmatch(line)
		if m == nil {
			panic("invalid line " + line)
		}
		i1, err := strconv.Atoi(m[1])
		if err != nil {
			panic(err)
		}
		i2, err := strconv.Atoi(m[2])
		if err != nil {
			panic(err)
		}
		ent = append(ent, &Ent{i1, i2, m[3][0], m[4]})
	}
	return &DB{ent, false}
}

func (db *DB) Part1() int {
	c := 0
	for _, e := range db.entries {
		cc := 0
		for i := range e.pw {
			if e.pw[i] == e.ch {
				cc++
			}
		}
		if cc >= e.i1 && cc <= e.i2 {
			c++
		}
	}
	return c
}

func (db *DB) Part2() int {
	c := 0
	for _, e := range db.entries {
		first := e.pw[e.i1-1] == e.ch
		second := e.pw[e.i2-1] == e.ch
		if (first || second) && !(first && second) {
			c++
		}
	}
	return c
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	db := NewDB(lines)
	fmt.Printf("Part 1: %d\n", db.Part1())
	fmt.Printf("Part 2: %d\n", db.Part2())
}
