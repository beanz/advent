package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Axis bool

const (
	XAxis Axis = true
	YAxis      = false
)

type Fold struct {
	n    int
	axis Axis
}

type Game struct {
	m    map[int]bool
	f    []Fold
	w, h int
}

func NewGame(in []byte) *Game {
	m := make(map[int]bool, 1024)
	w := 0
	h := 0
	i := 0
	y := 0 // sometimes x!
	x := 0
LOOP:
	for ; i < len(in); i++ {
		switch in[i] {
		case ',':
			x = y
			y = 0
		case '\n':
			if x > w {
				w = x
			}
			if y > h {
				h = y
			}
			m[x+(y<<12)] = true
			y = 0
			if in[i+1] == '\n' {
				i += 2
				break LOOP
			}
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			y = y*10 + int(in[i]-'0')
		}
	}
	var axis Axis
	f := make([]Fold, 0, 16)
	for ; i < len(in); i++ {
		switch in[i] {
		case 'x':
			axis = XAxis
		case 'y':
			axis = YAxis
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			y = y*10 + int(in[i]-'0')
		case '\n':
			f = append(f, Fold{y, axis})
			y = 0
		}
	}
	return &Game{m, f, w, h}
}

func (g *Game) String() string {
	var sb strings.Builder
	for y := 0; y <= g.h; y++ {
		for x := 0; x <= g.w; x++ {
			if g.m[x+(y<<12)] {
				sb.WriteByte('#')
			} else {
				sb.WriteByte(' ')
			}
		}
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (g *Game) Parts() (int, string) {
	p1 := -1
	for _, f := range g.f {
		if f.axis == XAxis {
			// fold x
			w := 0
			for xy := range g.m {
				x, y := xy%4096, xy>>12
				if x > f.n {
					delete(g.m, xy)
					x = f.n - (x - f.n)
					g.m[x+(y<<12)] = true
				}
				if x > w {
					w = x
				}
			}
			g.w = w
		} else {
			// fold y
			h := 0
			for xy := range g.m {
				x, y := xy%4096, xy>>12
				if y > f.n {
					delete(g.m, xy)
					y = f.n - (y - f.n)
					g.m[x+(y<<12)] = true
				}
				if y > h {
					h = y
				}
			}
			g.h = h
		}
		if p1 == -1 {
			p1 = len(g.m)
		}
	}
	return p1, g.String()
}

func main() {
	g := NewGame(InputBytes(input))
	p1, p2 := g.Parts()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2:\n%s", p2)
	}
}

var benchmark = false
