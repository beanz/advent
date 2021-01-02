package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	m       map[Point]byte
	bb      *BoundingBox
	numbers map[byte]Point
	debug   bool
}

func (g *Game) String() string {
	s := ""
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		for x := g.bb.Min.X; x <= g.bb.Max.X; x++ {
			s += string(g.m[Point{x, y}])
		}
		s += "\n"
	}
	for k, v := range g.numbers {
		s += fmt.Sprintf("%d: %s\n", k, v)
	}
	return s
}

func readGame(lines []string) *Game {
	bb := &BoundingBox{Point{0, 0}, Point{len(lines[0]) - 1, len(lines)}}
	g := &Game{map[Point]byte{}, bb, map[byte]Point{}, false}
	for y, l := range lines {
		for x, ch := range l {
			b := byte(ch)
			if 48 <= b && b <= 57 {
				num := b - 48
				g.numbers[num] = Point{x, y}
			}
			g.m[Point{x, y}] = byte(ch)
		}
	}
	return g
}

type Search struct {
	p     Point
	steps int
}

func (g *Game) DistanceBetween(i, j byte) int {
	todo := []Search{Search{g.numbers[i], 0}}
	visited := map[Point]bool{}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if visited[cur.p] {
			continue
		}
		visited[cur.p] = true
		for _, np := range cur.p.Neighbours() {
			if g.m[np] == '#' {
				continue
			}
			if np == g.numbers[j] {
				return cur.steps + 1
			}
			todo = append(todo, Search{np, cur.steps + 1})
		}
	}
	return -1
}

type Pair struct {
	i, j byte
}

type Distances map[Pair]int

func (g *Game) CalculateDistances() Distances {
	dist := Distances{}
	for i := range g.numbers {
		for j := range g.numbers {
			if j <= i {
				continue
			}
			d := g.DistanceBetween(i, j)
			dist[Pair{i, j}] = d
			dist[Pair{j, i}] = d
			//fmt.Printf("%d -> %d = %d\n", i, j, d)
		}
	}
	return dist
}

func (g *Game) Part1() int {
	dist := g.CalculateDistances()
	min := 1000000000
	for _, p := range Permutations(1, len(g.numbers)-1) {
		d := dist[Pair{0, byte(p[0])}]
		for i := 0; i < len(p)-1; i++ {
			sd := dist[Pair{byte(p[i]), byte(p[i+1])}]
			//fmt.Printf("%d => %d: %d\n", p[i], p[i+1], sd)
			d += sd
		}
		if min > d {
			min = d
		}
		//fmt.Println()
	}
	return min
}

func (g *Game) Part2() int {
	dist := g.CalculateDistances()
	min := 1000000000
	for _, p := range Permutations(1, len(g.numbers)-1) {
		d := dist[Pair{0, byte(p[0])}]
		for i := 0; i < len(p)-1; i++ {
			sd := dist[Pair{byte(p[i]), byte(p[i+1])}]
			//fmt.Printf("%d => %d: %d\n", p[i], p[i+1], sd)
			d += sd
		}
		d += dist[Pair{0, byte(p[len(p)-1])}]
		if min > d {
			min = d
		}
		//fmt.Println()
	}
	return min
}

func main() {
	game := readGame(ReadInputLines())
	fmt.Printf("Part 1: %d\n", game.Part1())

	game = readGame(ReadInputLines())
	fmt.Printf("Part 2: %d\n", game.Part2())
}
