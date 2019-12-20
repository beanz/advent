package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Portal struct {
	exit  Point
	name  string
	level int
}

type Donut struct {
	m     map[Point]bool
	p     map[Point]Portal
	bb    *BoundingBox
	start Point
	exit  Point
	debug bool
}

func (d *Donut) String() string {
	s := ""
	for y := d.bb.Min.Y; y <= d.bb.Max.Y; y++ {
		for x := d.bb.Min.X; x <= d.bb.Max.X; x++ {
			p := Point{x, y}
			if p == d.start {
				s += "S"
			} else if p == d.exit {
				s += "E"
			} else if _, ok := d.p[p]; ok {
				s += "~"
			} else if _, ok := d.m[p]; ok {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func NewDonut(lines []string) *Donut {
	d := &Donut{
		make(map[Point]bool),
		make(map[Point]Portal),
		NewBoundingBox(),
		Point{-1, -1},
		Point{-1, -1},
		false}
	rp := make(map[string]Point)
	lxy := func(x int, y int) byte {
		if y > d.bb.Max.Y || y < d.bb.Min.Y ||
			x > d.bb.Max.X || y < d.bb.Min.X {
			return '#'
		}
		return lines[y][x]
	}
	isPortal := func(ch byte) bool {
		return 'A' <= ch && ch <= 'Z'
	}
	addPortal := func(p Point, bx int, by int, ch1 byte, ch2 byte) {
		name := string(ch1) + string(ch2)
		d.m[Point{bx, by}] = true // block except warping
		if name == "AA" {
			d.start = p
			return
		}
		if name == "ZZ" {
			d.exit = p
			return
		}
		level := 1
		if p.Y == d.bb.Min.Y+2 ||
			p.Y == d.bb.Max.Y-2 ||
			p.X == d.bb.Min.X+2 ||
			p.X == d.bb.Max.X-2 {
			// outer portal
			level = -1
		}
		if exit, ok := rp[name]; ok {
			// have other end already
			d.p[p] = Portal{exit, name, level}
			d.p[exit] = Portal{p, name, -1 * level}
			delete(rp, name)
		} else {
			rp[name] = p
		}
	}
	d.bb.Add(Point{0, 0})
	d.bb.Add(Point{len(lines[0]) - 1, len(lines) - 1})
	for y, line := range lines {
		for x, ch := range line {
			p := Point{x, y}
			if ch == '#' {
				d.bb.Add(p)
				d.m[p] = true
			} else if ch == '.' {
				if isPortal(lxy(x, y-2)) &&
					isPortal(lxy(x, y-1)) {
					addPortal(p, x, y-1, lxy(x, y-2), lxy(x, y-1))
				} else if isPortal(lxy(x, y+1)) &&
					isPortal(lxy(x, y+2)) {
					addPortal(p, x, y+1, lxy(x, y+1), lxy(x, y+2))
				} else if isPortal(lxy(x-2, y)) &&
					isPortal(lxy(x-1, y)) {
					addPortal(p, x-1, y, lxy(x-2, y), lxy(x-1, y))
				} else if isPortal(lxy(x+1, y)) &&
					isPortal(lxy(x+2, y)) {
					addPortal(p, x+1, y, lxy(x+1, y), lxy(x+2, y))
				}
			}
		}
	}
	return d
}

type Search struct {
	pos   Point
	steps int
	level int
	path  []string
}

func (s Search) vKey() string {
	return fmt.Sprintf("%d,%d^%d", s.pos.X, s.pos.Y, s.level)
}

func (d *Donut) Search(recurse bool) int {
	todo := []Search{Search{d.start, 0, 0, []string{}}}
	visited := make(map[string]bool)
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		vkey := cur.vKey()
		if _, ok := visited[vkey]; ok {
			continue
		}
		visited[vkey] = true
		if _, ok := d.m[cur.pos]; ok {
			continue
		}
		// fmt.Printf("Trying %s @ %d (%d %v)\n",
		// 	cur.pos, cur.level, cur.steps, cur.path)
		if cur.level == 0 &&
			cur.pos.X == d.exit.X && cur.pos.Y == d.exit.Y {
			return cur.steps
		}
		if portal, ok := d.p[cur.pos]; ok {
			nlevel := cur.level
			if recurse {
				nlevel += portal.level
			}
			// fmt.Printf("  found %s to %s, level %d\n",
			// 	portal.name, portal.exit, nlevel)
			if nlevel >= 0 {
				npath := append(cur.path, portal.name)
				todo = append(todo,
					Search{portal.exit, cur.steps + 1, nlevel, npath})
			}
		}
		for _, np := range cur.pos.Neighbours() {
			todo = append(todo,
				Search{np, cur.steps + 1, cur.level, cur.path})
		}
	}
	return -1
}

func (d *Donut) Part1() int {
	return d.Search(false)
}

func (d *Donut) Part2() int {
	return d.Search(true)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	donut := NewDonut(lines)
	//fmt.Print("%s\n", donut)
	fmt.Printf("Part 1: %d\n", donut.Part1())
	fmt.Printf("Part 2: %d\n", donut.Part2())
}
