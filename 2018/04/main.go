package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"sort"
	"strconv"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	events []string
	debug  bool
}

func NewGame(lines []string) *Game {
	sort.Strings(lines)
	return &Game{lines, false}
}

type GuardMin struct {
	id, min int
}

func (g *Game) Part1() int {
	guardRe := regexp.MustCompile(`\d{2}\] Guard #(\d+)`)
	sleepRe := regexp.MustCompile(`(\d{2})\] falls`)
	wakeRe := regexp.MustCompile(`(\d{2})\] wake`)
	counts := make(map[int]int)
	mins := make(map[GuardMin]int)
	maxMin := make(map[int]int)
	maxID := -1
	guardID := -1
	start := 0
	for _, line := range g.events {
		if m := guardRe.FindStringSubmatch(line); m != nil {
			guardID, _ = strconv.Atoi(m[1])
		} else if m := sleepRe.FindStringSubmatch(line); m != nil {
			start, _ = strconv.Atoi(m[1])
		} else if m := wakeRe.FindStringSubmatch(line); m != nil {
			end, _ := strconv.Atoi(m[1])
			counts[guardID] += end - start
			if maxID == -1 || counts[guardID] > counts[maxID] {
				maxID = guardID
			}
			for min := start; min < end; min++ {
				k := GuardMin{guardID, min}
				mins[GuardMin{guardID, min}]++
				keyMax := GuardMin{guardID, maxMin[guardID]}
				if mins[k] > mins[keyMax] {
					maxMin[guardID] = min
				}
			}
		}
	}
	return maxID * maxMin[maxID]
}

func (g *Game) Part2() int {
	guardRe := regexp.MustCompile(`\d{2}\] Guard #(\d+)`)
	sleepRe := regexp.MustCompile(`(\d{2})\] falls`)
	wakeRe := regexp.MustCompile(`(\d{2})\] wake`)

	mins := make(map[GuardMin]int)
	maxID, maxMin := -1, -1
	guardID := -1
	start := 0
	for _, line := range g.events {
		if m := guardRe.FindStringSubmatch(line); m != nil {
			guardID, _ = strconv.Atoi(m[1])
		} else if m := sleepRe.FindStringSubmatch(line); m != nil {
			start, _ = strconv.Atoi(m[1])
		} else if m := wakeRe.FindStringSubmatch(line); m != nil {
			end, _ := strconv.Atoi(m[1])
			for min := start; min < end; min++ {
				k := GuardMin{guardID, min}
				mins[k]++
				keyMax := GuardMin{maxID, maxMin}
				if mins[k] > mins[keyMax] {
					maxID, maxMin = guardID, min
				}
			}
		}
	}
	return maxID * maxMin
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}
