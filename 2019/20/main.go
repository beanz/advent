package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Portal struct {
	exit FP3
	name string
}

type Donut struct {
	m     []bool
	p     map[FP3]Portal
	bb    *BoundingBox
	start FP3
	exit  FP3
	debug bool
}

func (d *Donut) String() string {
	s := ""
	for y := d.bb.Min.Y; y <= d.bb.Max.Y; y++ {
		for x := d.bb.Min.X; x <= d.bb.Max.X; x++ {
			p := NewFP3(int16(x), int16(y), 0)
			if p == d.start {
				s += "S"
			} else if p == d.exit {
				s += "E"
			} else if _, ok := d.p[p]; ok {
				s += "~"
			} else if d.m[x+128*y] {
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
		make([]bool, 65536),
		make(map[FP3]Portal),
		NewBoundingBox(),
		FP3(0),
		FP3(0),
		false}
	rp := make(map[string]FP3)
	lxy := func(x int16, y int16) byte {
		if int(y) > d.bb.Max.Y || int(y) < d.bb.Min.Y ||
			int(x) > d.bb.Max.X || int(y) < d.bb.Min.X {
			return '#'
		}
		return lines[y][x]
	}
	isPortal := func(ch byte) bool {
		return 'A' <= ch && ch <= 'Z'
	}
	addPortal := func(p FP3, bx int16, by int16, ch1 byte, ch2 byte) {
		name := string(ch1) + string(ch2)
		d.m[bx+128*by] = true // block except warping
		if name == "AA" {
			d.start = p
			return
		}
		if name == "ZZ" {
			d.exit = p
			return
		}
		var level int16 = 1
		x, y, _ := p.XYZ()
		if y == int16(d.bb.Min.Y+2) ||
			y == int16(d.bb.Max.Y-2) ||
			x == int16(d.bb.Min.X+2) ||
			x == int16(d.bb.Max.X-2) {
			// outer portal
			level = -1
		}
		if exit, ok := rp[name]; ok {
			// have other end already
			ex, ey, _ := exit.XYZ()
			exitWithLevel := NewFP3(ex, ey, level)
			startWithLevel := NewFP3(x, y, -1*level)
			d.p[p] = Portal{exitWithLevel, name}
			d.p[exit] = Portal{startWithLevel, name}
			delete(rp, name)
		} else {
			rp[name] = p
		}
	}
	d.bb.Add(Point{0, 0})
	d.bb.Add(Point{len(lines[0]) - 1, len(lines) - 1})
	for yi, line := range lines {
		y := int16(yi)
		for xi, ch := range line {
			x := int16(xi)
			p := NewFP3(x, y, 0)
			if ch == '#' {
				d.bb.Add(Point{int(x), int(y)})
				d.m[x+128*y] = true
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
	pos   FP3
	steps int
}

func (d *Donut) Search(recurse bool) int {
	todo := make([]Search, 0, 720)
	todo = append(todo, Search{d.start, 0})
	ox := []int16{0, 1, 0, -1}
	oy := []int16{-1, 0, 1, 0}
	exit := d.exit.ProjXY() // level 0
	visited := make([]bool, FP3UKeyMax(7, 7))
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		vkey := cur.pos.UKey(7, 7)
		if visited[vkey] {
			continue
		}
		visited[vkey] = true
		x, y, level := cur.pos.XYZ()
		pos2d := cur.pos.ProjXY()
		if d.m[x+128*y] {
			continue
		}
		// fmt.Printf("Trying %s @ %d (%d %v)\n",
		// 	cur.pos, cur.level, cur.steps, cur.path)
		if cur.pos == exit {
			return cur.steps
		}
		if portal, ok := d.p[pos2d]; ok {
			px, py, plevel := portal.exit.XYZ()
			nlevel := level
			if recurse {
				nlevel += plevel
			}
			// fmt.Printf("  found %s to %s, level %d\n",
			// 	portal.name, portal.exit, nlevel)
			if nlevel >= 0 {
				todo = append(todo,
					Search{NewFP3(px, py, nlevel), cur.steps + 1})
			}
		}
		for i := 0; i < 4; i++ {
			todo = append(todo,
				Search{NewFP3(x+ox[i], y+oy[i], level),
					cur.steps + 1})
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
	lines := InputLines(input)
	donut := NewDonut(lines)
	//fmt.Print("%s\n", donut)
	p1 := donut.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := donut.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
