package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Move int

const (
	Forward Move = iota
	Down
	Up
)

type Cmd struct {
	move  Move
	units int
}

type Game struct {
	cmds []Cmd
}

func NewGame(in []string) *Game {
	g := &Game{make([]Cmd, len(in))}
	for i, l := range in {
		units := Ints(l)[0]
		switch l[0] {
		case 'f':
			g.cmds[i] = Cmd{Forward, units}
		case 'd':
			g.cmds[i] = Cmd{Down, units}
		case 'u':
			g.cmds[i] = Cmd{Up, units}
		}
	}
	return g
}

func (g *Game) Move() (int, int) {
	p1, p2 := Point{X: 0, Y: 0}, Point3D{X: 0, Y: 0, Z: 0} // Z=aim
	for _, cmd := range g.cmds {
		switch cmd.move {
		case Forward:
			p1.X += cmd.units
			p2.X += cmd.units
			p2.Y += p2.Z * cmd.units
		case Down:
			p1.Y += cmd.units
			p2.Z += cmd.units
		case Up:
			p1.Y -= cmd.units
			p2.Z -= cmd.units
		}
	}
	return p1.X * p1.Y, p2.X * p2.Y
}

func main() {
	cmds := ReadInputLines()
	g := NewGame(cmds)
	p1, p2 := g.Move()
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
