package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

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

func NeighbourSum(m map[Point]int, p Point) int {
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
		cur.X++
		g[cur] = NeighbourSum(g, cur)
		if g[cur] > in {
			return g[cur]
		}
		for y := 0; y < i-1; y++ {
			cur.Y++
			g[cur] = NeighbourSum(g, cur)
			if g[cur] > in {
				return g[cur]
			}
		}
		for x := 0; x < i; x++ {
			cur.X--
			g[cur] = NeighbourSum(g, cur)
			if g[cur] > in {
				return g[cur]
			}
		}
		for y := 0; y < i; y++ {
			cur.Y--
			g[cur] = NeighbourSum(g, cur)
			if g[cur] > in {
				return g[cur]
			}
		}
		for x := 0; x < i; x++ {
			cur.X++
			g[cur] = NeighbourSum(g, cur)
			if g[cur] > in {
				return g[cur]
			}
		}
	}
	return -1
}

func main() {
	input := ReadInputInts()[0]
	res := Part1(input)
	fmt.Printf("Part 1: %d\n", res)

	res = Part2(input)
	fmt.Printf("Part 2: %d\n", res)
}
