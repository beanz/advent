package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Range struct {
	min, max int
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
		min, err := strconv.Atoi(r[0])
		if err != nil {
			log.Fatalf("invalid min in line:\n%s\n", line)
		}
		max, err := strconv.Atoi(r[1])
		if err != nil {
			log.Fatalf("invalid max in line:\n%s\n", line)
		}
		g.ranges = append(g.ranges, &Range{min, max})
	}
	sort.Sort(RangeOrder(g.ranges))
	return g
}

func (g Game) Part1() int {
	num := 0
	for _, r := range g.ranges {
		if r.min <= num {
			num = r.max + 1
		} else {
			return num
		}
	}
	return num
}

func (g Game) Part2(max int) int {
	count := 0
	num := 0
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game := readGame(ReadLines(input))

	fmt.Printf("Part 1: %d\n", game.Part1())
	fmt.Printf("Part 2: %d\n", game.Part2(4294967295))
}
