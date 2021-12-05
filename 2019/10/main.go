package main

import (
	"fmt"
	"math"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

type VisitKey struct {
	a1, a2 Point
}

type Game struct {
	a     map[Point]int
	bb    *BoundingBox
	vc    map[VisitKey]bool
	best  Point
	debug bool
}

func (g *Game) String() string {
	s := ""
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		for x := g.bb.Min.X; x <= g.bb.Max.X; x++ {
			if _, ok := g.a[Point{x, y}]; ok {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func NewGame(lines []string) *Game {
	bb := NewBoundingBox()
	bb.Add(Point{0, 0})
	best := Point{-1, 1}
	a := make(map[Point]int)
	for y, line := range lines {
		for x, ch := range line {
			if ch == '#' {
				p := Point{x, y}
				bb.Add(p)
				a[p] = 0
			} else if ch == 'X' {
				p := Point{x, y}
				bb.Add(p)
				a[p] = 0
				best = p
			}
		}
	}
	g := &Game{a, bb, make(map[VisitKey]bool), best, false}
	return g
}

func (g *Game) visible(a1, a2 Point) bool {
	if v, ok := g.vc[VisitKey{a1, a2}]; ok {
		return v
	}
	res := true
	dx := a2.X - a1.X
	dy := a2.Y - a1.Y
	//fmt.Printf("%s => %s\n  d=[%d,%d]\n", a1, a2, dx, dy)
	if dx != 0 || dy != 0 {
		gcd := int(GCD(int64(dx), int64(dy)))
		dx /= gcd
		dy /= gcd
		//fmt.Printf("  sd=[%d,%d]\n", dx, dy)
	}
	p := Point{a1.X + dx, a1.Y + dy}
	for p != a2 {
		//fmt.Printf("  checking %s\n", p)
		if _, ok := g.a[p]; ok {
			//fmt.Printf("  blocked by %s\n", p)
			res = false
			break
		}
		p = Point{p.X + dx, p.Y + dy}
	}
	g.vc[VisitKey{a1, a2}] = res
	g.vc[VisitKey{a2, a1}] = res
	return res
}

func (g *Game) Part1() int {
	max := math.MinInt64
	for a1 := range g.a {
		c := 0
		for a2 := range g.a {
			if a1 == a2 {
				continue
			}
			if g.visible(a1, a2) {
				c++
			}
		}
		if max < c {
			max = c
			g.best = a1
		}
	}
	return max
}

func angle(a1, a2 Point) float64 {
	a := math.Atan2(float64(a2.X-a1.X), float64(a1.Y-a2.Y))
	for a < 0 {
		a += math.Atan2(0, -1) * 2
	}
	return a
}

func dist(a1, a2 Point) int {
	return (a1.X-a2.X)*(a1.X-a2.X) + (a1.Y-a2.Y)*(a1.Y-a2.Y)
}

type PointDist struct {
	point Point
	dist  int
}

type PointDistOrder []PointDist

func (p PointDistOrder) Len() int {
	return len(p)
}

func (p PointDistOrder) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func (p PointDistOrder) Less(i, j int) bool {
	return p[i].dist < p[j].dist
}

func (g *Game) Part2(num int) int {
	angles := make(map[float64][]PointDist)
	a1 := g.best
	for a2 := range g.a {
		if a1 == a2 {
			continue
		}
		angle := angle(a1, a2)
		if _, ok := angles[angle]; !ok {
			angles[angle] = []PointDist{}
		}
		dist := dist(a1, a2)
		angles[angle] = append(angles[angle], PointDist{a2, dist})
	}
	c := 1
	for len(angles) > 0 {
		s := make([]float64, 0, len(angles))
		for angle := range angles {
			s = append(s, angle)
			line := angles[angle]
			sort.Sort(PointDistOrder(line))
			angles[angle] = line
		}
		sort.Float64s(s)
		for _, angle := range s {
			//fmt.Printf("%f %d\n", angle, len(angles[angle]))
			pd := angles[angle][0]
			if len(angles[angle]) == 1 {
				delete(angles, angle)
			} else {
				angles[angle] = angles[angle][1:]
			}
			//fmt.Printf("blasting %s\n", pd.point)
			if c == num {
				return pd.point.X*100 + pd.point.Y
			}
			c++
		}
	}
	return -1
}

func main() {
	lines := ReadInputLines()
	g := NewGame(lines)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2(200))
}
