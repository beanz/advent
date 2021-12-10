package main

import (
	_ "embed"
	"fmt"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Range struct {
	min, max int64
}

type RangeOrder []*Range

func (r RangeOrder) Len() int {
	return len(r)
}

func (r RangeOrder) Swap(i, j int) {
	r[i], r[j] = r[j], r[i]
}

func (r RangeOrder) Less(i, j int) bool {
	return r[i].min < r[j].min
}

type Game struct {
	ranges []*Range
	debug  bool
}

func readGame(lines []string) *Game {
	g := &Game{[]*Range{}, false}
	for _, line := range lines {
		r := strings.Split(line, "-")
		min := MustParseInt64(r[0])
		max := MustParseInt64(r[1])
		g.ranges = append(g.ranges, &Range{min, max})
	}
	sort.Sort(RangeOrder(g.ranges))
	return g
}

func (g Game) Part1() int64 {
	num := int64(0)
	for _, r := range g.ranges {
		if r.min <= num {
			num = r.max + 1
		} else {
			return num
		}
	}
	return num
}

func (g Game) Part2(max int64) int64 {
	count := int64(0)
	num := int64(0)
	for _, r := range g.ranges {
		if g.debug {
			fmt.Printf("Testing %d against %d - %d \n", num, r.min, r.max)
		}
		if r.min > num {
			if g.debug {
				fmt.Printf("Adding %d to %d\n", num, r.min-1)
			}
			count += r.min - num
		}
		if num <= r.max {
			num = r.max + 1
		}
	}
	if num <= max {
		if g.debug {
			fmt.Printf("Adding %d to %d\n", num, max)
		}
		count += 1 + max - num
	}
	return count
}

func main() {
	game := readGame(InputLines(input))

	p1 := game.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := game.Part2(4294967295)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
