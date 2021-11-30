package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Door struct {
	p   Point
	dir Compass
}

type Game struct {
	regex string
	bb    *BoundingBox
	doors map[Point]map[Compass]bool
	debug bool
}

func (g *Game) DoorAt(p Point, dir Compass) bool {
	if v, ok := g.doors[p]; ok {
		return v[dir]
	}
	return false
}

func (g *Game) RoomAt(p Point) bool {
	_, ok := g.doors[p]
	return ok
}

func (g *Game) String() string {
	s := fmt.Sprintf("Regex: %s\n", g.regex)
	var s1 string
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		s1 = ""
		s2 := ""
		for x := g.bb.Min.X; x <= g.bb.Max.X; x++ {
			p := Point{x, y}
			s1 += "#"
			if g.DoorAt(p, "N") {
				s1 += "-"
			} else {
				s1 += "#"
			}
			if g.DoorAt(p, "W") {
				s2 += "|"
			} else {
				s2 += "#"
			}
			if x == 0 && y == 0 {
				s2 += "X"
			} else if g.RoomAt(p) {
				s2 += "."
			} else {
				s2 += "#"
			}
		}
		s += s1 + "#\n"
		s += s2 + "#\n"
	}
	s += strings.Repeat("#", 1+len(s1))
	return s
}

func NewGame(lines []string) *Game {
	g := &Game{lines[0], NewBoundingBox(), map[Point]map[Compass]bool{}, false}
	g.bb.Add(Point{0, 0})
	return g
}

func (g *Game) AddDoor(p1 Point, dir Compass, p2 Point) {
	if _, ok := g.doors[p1]; !ok {
		g.doors[p1] = map[Compass]bool{}
	}
	if _, ok := g.doors[p2]; !ok {
		g.doors[p2] = map[Compass]bool{}
	}
	g.doors[p1][dir] = true
	g.doors[p2][dir.Opposite()] = true
}

func (g *Game) Rooms() {
	s := g.regex
	p := Point{0, 0}
	stack := []Point{}
	for _, r := range s {
		switch r {
		case '^':
			// nothing
		case 'N', 'S', 'E', 'W':
			c := Compass(string(r))
			d := c.Direction()
			np := p.In(d)
			g.bb.Add(np)
			g.AddDoor(p, c, np)
			p = np
		case '(':
			stack = append(stack, p)
		case '|':
			p = stack[len(stack)-1]
		case ')':
			stack = stack[:len(stack)-1]
		case '$':
			if len(stack) != 0 {
				log.Fatalf("Expected empty stack but length was %d\n",
					len(stack))
			}
		default:
			log.Fatalf("Expected character in regex: %s\n", string(r))
		}
	}
}

type Search struct {
	p    Point
	dist int
}

func (g *Game) Run(cutoff int) (int, int) {
	g.Rooms()
	todo := []Search{Search{Point{0, 0}, 0}}
	seen := map[Point]bool{}
	max := math.MinInt64
	count := 0
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		for _, dir := range []Compass{Compass('N'), Compass('S'),
			Compass('E'), Compass('W')} {
			if !g.DoorAt(cur.p, dir) {
				continue
			}
			np := cur.p.In(dir.Direction())
			if seen[np] {
				continue
			}
			seen[np] = true
			dist := cur.dist + 1
			if max < dist {
				max = dist
			}
			if dist >= cutoff {
				count++
			}
			todo = append(todo, Search{np, dist})
		}
	}
	return max, count
}

func (g *Game) Part1() int {
	max, _ := g.Run(1000)
	return max
}

func (g *Game) Part2(cutoff int) int {
	_, count := g.Run(cutoff)
	return count
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", g.Part1())
	g = NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 2: %d\n", g.Part2(1000))
}
