package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Game struct {
	state []string
	w, h  int
	debug bool
}

func (g *Game) String() string {
	return fmt.Sprintf("%dx%d", g.w, g.h)
}

func NewGame(lines []string) *Game {
	g := &Game{lines, len(lines[0]), len(lines), false}
	return g
}

func (g *Game) Start() Point {
	return Point{strings.Index(g.state[0], "|"), 0}
}

func (g *Game) At(p Point) byte {
	if p.X >= g.w || p.X < 0 || p.Y >= g.h || p.Y < 0 {
		return ' '
	}
	return g.state[p.Y][p.X]
}

func (g *Game) Play() (string, int) {
	cur := g.Start()
	dir := Compass("S").Direction()
	letters := ""
	steps := 0
	for {
		sq := g.At(cur)
		if g.debug {
			fmt.Printf("Sq='%s' dir=%s\n", string(sq), dir)
		}
		if sq == ' ' {
			break
		}
		if sq == '+' {
			// turn
			switch {
			case g.At(cur.In(dir.CW())) != ' ':
				dir = dir.CW()
			case g.At(cur.In(dir.CCW())) != ' ':
				dir = dir.CCW()
			default:
				log.Fatalf("No turn possible at %s in direction %s\n",
					cur, dir)
			}
		}
		if strings.Index("ABCDEFGHIJKLMNOPQRSTUVWXYZ", string(sq)) != -1 {
			letters += string(sq)
		}
		cur.X += dir.Dx
		cur.Y += dir.Dy
		steps++
		if g.debug {
			fmt.Printf("%s %s %s\n", g, cur, letters)
		}
	}
	return letters, steps
}

func (g *Game) Part1() string {
	letters, _ := g.Play()
	return letters
}

func (g *Game) Part2() int {
	_, steps := g.Play()
	return steps
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %s\n", NewGame(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewGame(lines).Part2())
}