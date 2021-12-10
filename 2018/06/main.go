package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	c     []Point
	bb    *BoundingBox
	bound int
	debug bool
}

func NewGame(lines []string) *Game {
	g := &Game{[]Point{}, NewBoundingBox(),
		SimpleReadInts(lines[0])[0], false}
	for _, line := range lines[1:] {
		coords := SimpleReadInts(line)
		p := Point{coords[0], coords[1]}
		g.c = append(g.c, p)
		g.bb.Add(p)
	}
	return g
}

func ClosestPoint(p Point, points []Point) int {
	min := math.MaxInt64
	minIndex := -1
	for i, tp := range points {
		md := p.ManhattanDistance(tp)
		if md < min {
			min = md
			minIndex = i
		} else if md == min {
			minIndex = -1
		}
	}
	return minIndex
}

func getAreas(bb BoundingBox, points []Point) map[int]int {
	res := make(map[int]int)
	for y := bb.Min.Y; y <= bb.Max.Y; y++ {
		for x := bb.Min.X; x <= bb.Max.Y; x++ {
			p := Point{x, y}
			closest := ClosestPoint(p, points)
			if closest != -1 {
				res[closest]++
			}
		}
	}
	return res
}

func (g *Game) Part1() int {
	inf := make(map[int]bool)
	for _, bbEdge := range []BoundingBox{
		BoundingBox{Point{g.bb.Min.X - 1, g.bb.Min.Y},
			Point{g.bb.Max.X + 1, g.bb.Min.Y}},
		BoundingBox{Point{g.bb.Min.X - 1, g.bb.Max.Y},
			Point{g.bb.Max.X + 1, g.bb.Max.Y}},
		BoundingBox{Point{g.bb.Min.X, g.bb.Min.Y - 1},
			Point{g.bb.Min.X, g.bb.Max.Y + 1}},
		BoundingBox{Point{g.bb.Min.X, g.bb.Min.Y - 1},
			Point{g.bb.Max.X, g.bb.Max.Y + 1}},
	} {
		areasEdge := getAreas(bbEdge, g.c)
		for k := range areasEdge {
			inf[k] = true
		}
	}
	areas := getAreas(*g.bb, g.c)
	maxArea := math.MinInt64
	for i, a := range areas {
		if _, ok := inf[i]; ok && maxArea < a {
			maxArea = a
		}
	}

	return maxArea
}

func sumDist(p Point, points []Point) int {
	s := 0
	for _, tp := range points {
		s += p.ManhattanDistance(tp)
	}
	return s
}

func (g *Game) Part2() int {
	bound := int(math.Floor(math.Sqrt(float64(g.bound))))

	area := 0
	for y := g.bb.Min.Y - bound; y < g.bb.Max.Y+bound; y++ {
		for x := g.bb.Min.X - bound; x < g.bb.Max.X+bound; x++ {
			if sumDist(Point{x, y}, g.c) < g.bound {
				area++
			}
		}
	}
	return area
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
