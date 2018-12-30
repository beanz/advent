package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
)

type Point struct {
	x, y int
}

func (p Point) String() string {
	return fmt.Sprintf("%d,%d", p.x, p.y)
}

func (p Point) Neighbours() []Point {
	n := []Point{}
	n = append(n, Point{p.x, p.y - 1})
	n = append(n, Point{p.x - 1, p.y})
	n = append(n, Point{p.x + 1, p.y})
	n = append(n, Point{p.x, p.y + 1})
	return n
}

func (p Point) Neighbours8() []Point {
	n := []Point{}
	n = append(n, Point{p.x - 1, p.y - 1})
	n = append(n, Point{p.x + 0, p.y - 1})
	n = append(n, Point{p.x + 1, p.y - 1})
	n = append(n, Point{p.x - 1, p.y + 0})
	n = append(n, Point{p.x + 1, p.y + 0})
	n = append(n, Point{p.x - 1, p.y + 1})
	n = append(n, Point{p.x + 0, p.y + 1})
	n = append(n, Point{p.x + 1, p.y + 1})
	return n
}

func (p Point) ManhattanDistance(o Point) int {
	return int(math.Abs(float64(p.x)-float64(o.x)) +
		math.Abs(float64(p.y)-float64(o.y)))
}

func FindPosition(in int) Point {
	var i int
	for i = 1; i*i < in; i += 2 {
	}
	sq := i * i
	switch {
	case in == sq:
		return Point{i / 2, i / 2}
	case in < sq-(i-1)*3:
		y := (in - (sq - (i-1)*3)) + i/2
		return Point{(i / 2), -y}
	case in < sq-(i-1)*2:
		x := (in - (sq - (i-1)*2)) + i/2
		return Point{-x, -(i / 2)}
	case in < sq-(i-1):
		y := (in - (sq - (i - 1))) + i/2
		return Point{-(i / 2), y}
	default:
		x := (in - sq) + i/2
		return Point{x, i / 2}
	}
}

func Part1(in int) int {
	p := FindPosition(in)
	return p.ManhattanDistance(Point{0, 0})
}

func (p Point) NeighbourSum(m map[Point]int) int {
	s := 0
	for _, np := range p.Neighbours8() {
		if v, ok := m[np]; ok {
			s += v
		}
	}
	return s
}

func Part2(in int) int {
	g := map[Point]int{}
	g[Point{0, 0}] = 1
	cur := Point{0, 0}
	for i := 2; true; i += 2 {
		cur.x++
		g[cur] = cur.NeighbourSum(g)
		if g[cur] > in {
			return g[cur]
		}
		for y := 0; y < i-1; y++ {
			cur.y++
			g[cur] = cur.NeighbourSum(g)
			if g[cur] > in {
				return g[cur]
			}
		}
		for x := 0; x < i; x++ {
			cur.x--
			g[cur] = cur.NeighbourSum(g)
			if g[cur] > in {
				return g[cur]
			}
		}
		for y := 0; y < i; y++ {
			cur.y--
			g[cur] = cur.NeighbourSum(g)
			if g[cur] > in {
				return g[cur]
			}
		}
		for x := 0; x < i; x++ {
			cur.x++
			g[cur] = cur.NeighbourSum(g)
			if g[cur] > in {
				return g[cur]
			}
		}
	}
	return -1
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input, err := strconv.Atoi(os.Args[1])
	if err != nil {
		log.Fatalf("Invalid integer input %s: %s\n", os.Args[1], err)
	}

	res := Part1(input)
	fmt.Printf("Part 1: %d\n", res)

	res = Part2(input)
	fmt.Printf("Part 2: %d\n", res)
}
