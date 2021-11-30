package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Path map[Point]int

func Dir(d byte) Direction {
	switch d {
	case 'U':
		return Direction{0, -1}
	case 'D':
		return Direction{0, 1}
	case 'L':
		return Direction{-1, 0}
	case 'R':
		return Direction{1, 0}
	}
	return Direction{0, 0}
}

func FindPath(line string) Path {
	path := make(map[Point]int)
	p := Point{0, 0}
	steps := 0
	for _, m := range strings.Split(line, ",") {
		dir := Dir(m[0])
		c, _ := strconv.Atoi(m[1:])
		for i := 0; i < c; i++ {
			p = p.In(dir)
			steps++
			path[p] = steps
		}
	}
	return path
}

func Calc(lines []string) (int, int) {
	p1 := FindPath(lines[0])
	p2 := FindPath(lines[1])
	dist := math.MaxInt64
	steps := math.MaxInt64
	for p, s1 := range p1 {
		if s2, ok := p2[p]; ok {
			if s1+s2 < steps {
				steps = s1 + s2
			}
			d := p.ManhattanDistance(Point{0, 0})
			if d < dist {
				dist = d
			}
		}
	}
	return dist, steps
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	dist, steps := Calc(lines)
	fmt.Printf("Part 1: %d\n", dist)
	fmt.Printf("Part 2: %d\n", steps)
}
