package main

import (
	"fmt"
	"log"
	"regexp"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Disc struct {
	weight int
	subs   []string
}

type Tower struct {
	disc  map[string]*Disc
	debug bool
}

func (t *Tower) String() string {
	s := ""
	for w, d := range t.disc {
		s += fmt.Sprintf("%s (%d) %v\n", w, d.weight, d.subs)
	}
	return s
}

func NewTower(file string) *Tower {
	tower := &Tower{map[string]*Disc{}, false}
	lineRe := regexp.MustCompile(`^(\S+)\s+\((\d+)\)(.*)$`)
	for _, line := range ReadLines(file) {
		m := lineRe.FindStringSubmatch(line)
		if m == nil {
			log.Fatalf("Invalid line: %s\n", line)
		}
		word := m[1]
		weight, err := strconv.Atoi(m[2])
		if err != nil {
			log.Fatalf("Invalid weight in line: %s\n", line)
		}
		subs := []string{}
		if m[3] != "" {
			subs = strings.Split(strings.Replace(m[3], " -> ", "", -1), ", ")
		}
		tower.disc[word] = &Disc{weight, subs}
	}
	return tower
}

func (t *Tower) Bottom() string {
	seen := map[string]bool{}
	for _, d := range t.disc {
		for _, s := range d.subs {
			seen[s] = true
		}
	}
	for w := range t.disc {
		if !seen[w] {
			return w
		}
	}
	return "none"
}

func (t *Tower) Part1() string {
	return t.Bottom()
}

func (t *Tower) Weight(s string) int {
	disc := t.disc[s]
	w := disc.weight
	for _, s := range disc.subs {
		w += t.Weight(s)
	}
	return w
}

func (t *Tower) CheckWeight(s string, target int) int {
	disc := t.disc[s]
	weights := map[int][]string{}
	for _, s := range disc.subs {
		w := t.Weight(s)
		weights[w] = append(weights[w], s)
	}
	if len(weights) == 1 {
		// balanced
		sum := disc.weight
		var k int
		var v []string
		for k, v = range weights {
			sum += k * len(v)
		}
		if t.debug {
			fmt.Printf("%d + (%d * %d) = %d != %d\n",
				disc.weight, k, len(v), sum, target)
		}
		return disc.weight + target - sum
	}

	odd := ""
	expected := -1
	for k, v := range weights {
		if len(v) == 1 {
			odd = v[0]
		} else {
			expected = k
		}
	}
	if t.debug {
		fmt.Printf("Found odd one out %s\n", odd)
	}
	return t.CheckWeight(odd, expected)
}

func (t *Tower) Part2() int {
	b := t.Bottom()
	return t.CheckWeight(b, -1)
}

func main() {
	tower := NewTower(InputFile())
	fmt.Printf("Part 1: %s\n", tower.Part1())
	tower = NewTower(InputFile())
	fmt.Printf("Part 2: %d\n", tower.Part2())
}
