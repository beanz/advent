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

type BC struct {
	bt string
	c  int
}

type BS struct {
	graph    map[string][]string
	revgraph map[string][]*BC
	debug    bool
}

func NewBS(lines []string) *BS {
	bs := &BS{make(map[string][]string), make(map[string][]*BC), false}
	re := regexp.MustCompile(`(\d) (\w+ \w+) bag`)
	for _, l := range lines {
		sr := strings.Split(l, " bags contain ")
		bag := sr[0]
		spec := sr[1]
		//fmt.Printf("%s => %s\n", bag, spec)
		bags := re.FindAllStringSubmatch(spec, -1)
		for _, m := range bags {
			//fmt.Printf("  %s * %s\n", m[1], m[2])
			n, err := strconv.Atoi(m[1])
			if err != nil {
				panic(err)
			}
			innerBag := m[2]
			if _, ok := bs.graph[innerBag]; ok {
				bs.graph[innerBag] = append(bs.graph[innerBag], bag)
			} else {
				bs.graph[innerBag] = []string{bag}
			}
			bc := &BC{innerBag, n}
			if _, ok := bs.revgraph[bag]; ok {
				bs.revgraph[bag] = append(bs.revgraph[bag], bc)
			} else {
				bs.revgraph[bag] = []*BC{bc}
			}
		}
	}
	return bs
}

func (bs *BS) Traverse(bag string, acc map[string]bool) {
	for _, outerBag := range bs.graph[bag] {
		acc[outerBag] = true
		bs.Traverse(outerBag, acc)
	}
}

func (bs *BS) Part1() int {
	visited := make(map[string]bool)
	bs.Traverse("shiny gold", visited)
	return len(visited)
}

func (bs *BS) RevTraverse(bag string) int {
	c := 1
	if _, ok := bs.revgraph[bag]; !ok {
		return c
	}
	for _, bc := range bs.revgraph[bag] {
		c += bc.c * bs.RevTraverse(bc.bt)
	}
	return c
}

func (bs *BS) Part2() int {
	return bs.RevTraverse("shiny gold") - 1
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	bs := NewBS(lines)
	fmt.Printf("Part 1: %d\n", bs.Part1())
	fmt.Printf("Part 2: %d\n", bs.Part2())
}
