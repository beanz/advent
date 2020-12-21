package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Matcher struct {
	debug bool
}

func NewMatcher(in []string) *Matcher {
	return &Matcher{true}
}

func (m *Matcher) String() string {
	s := ""
	return s
}

func (m *Matcher) Part1() int {
	c := 0
	return c
}

func (m *Matcher) Part2() int {
	c := 0
	return c
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	chunks := ReadChunks(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewMatcher(chunks).Part1())
	fmt.Printf("Part 2: %d\n", NewMatcher(chunks).Part2())
}
