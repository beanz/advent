package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
	"strings"
)

//go:embed input.txt
var input []byte

type Axis byte

const (
	XAxis Axis = 0
	YAxis Axis = 1
)

type Fold struct {
	n    int
	axis Axis
}

type Game struct {
	m    map[int]struct{}
	f    []Fold
	wh [2]int
}

func NewGame(in []byte) *Game {
	p := make([][2]int, 0, 1000)
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
			p = append(p, [2]int{x,y})
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
	wh := [2]int{w,h}
	fold, f := f[0], f[1:]
	m := make(map[int]struct{}, 1024)
	for _, v := range p {
		i := 0
		if fold.axis == YAxis {
			i++
		}
		if v[i] > fold.n {
			v[i] = fold.n - (v[i] - fold.n)
		}
		m[v[0]+(v[1]<<12)] = struct{}{}
	}
	wh[fold.axis] = fold.n -1
	return &Game{m, f, wh}
}

func (g *Game) String() string {
	var sb strings.Builder
	for y := 0; y <= g.wh[1]; y++ {
		for x := 0; x <= g.wh[0]; x++ {
			if _, ok := g.m[x+(y<<12)]; ok {
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
	p1 := len(g.m)
	for _, f := range g.f {
		for xy := range g.m {
			v := [2]int{xy%4096, xy>>12}
			if v[f.axis] > f.n {
				delete(g.m, xy)
				v[f.axis] = f.n - (v[f.axis] - f.n)
				g.m[v[0]+(v[1]<<12)] = struct{}{}
			}
		}
		g.wh[f.axis] = f.n - 1
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
