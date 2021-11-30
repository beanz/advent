package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Pattern [][]byte

type Rule struct {
	from Pattern
	to   Pattern
}

func (p Rule) String() string {
	return fmt.Sprintf("from:\n%s\nto:\n%s", p.from, p.to)
}

func (p Pattern) Size() int {
	return len(p)
}

func (p Pattern) String() string {
	s := ""
	for _, row := range p {
		for _, sq := range row {
			s += fmt.Sprintf("%s", string(sq))
		}
		s += "\n"
	}
	return s
}

type Game struct {
	rules []Rule
	cur   *Pattern
	debug bool
}

func (g *Game) String() string {
	return fmt.Sprintf("%s", *g.cur)
}

func (g *Game) CountOn() int {
	c := 0
	for _, r := range *(g.cur) {
		c += strings.Count(string(r), "#")
	}
	return c
}

func NewPattern(s string) Pattern {
	p := Pattern{}
	for _, row := range strings.Split(s, "/") {
		r := []byte{}
		for i := 0; i < len(row); i++ {
			r = append(r, row[i])
		}
		p = append(p, r)
	}
	return p
}

func NewRule(s string) Rule {
	bits := strings.Split(s, " => ")
	return Rule{NewPattern(bits[0]), NewPattern(bits[1])}
}

func NewGame(lines []string) *Game {
	g := &Game{[]Rule{},
		&Pattern{
			[]byte{'.', '#', '.'},
			[]byte{'.', '.', '#'},
			[]byte{'#', '#', '#'},
		}, false}
	for _, line := range lines {
		g.rules = append(g.rules, NewRule(line))
	}
	return g
}

func (g *Game) Match2x2(from Pattern, sx, sy int) bool {
	return (from[0][0] == (*g.cur)[sy][sx] &&
		from[0][1] == (*g.cur)[sy][sx+1] &&
		from[1][0] == (*g.cur)[sy+1][sx] &&
		from[1][1] == (*g.cur)[sy+1][sx+1]) ||
		(from[0][1] == (*g.cur)[sy][sx] &&
			from[1][1] == (*g.cur)[sy][sx+1] &&
			from[0][0] == (*g.cur)[sy+1][sx] &&
			from[1][0] == (*g.cur)[sy+1][sx+1]) ||
		(from[1][1] == (*g.cur)[sy][sx] &&
			from[1][0] == (*g.cur)[sy][sx+1] &&
			from[0][1] == (*g.cur)[sy+1][sx] &&
			from[0][0] == (*g.cur)[sy+1][sx+1]) ||
		(from[1][0] == (*g.cur)[sy][sx] &&
			from[0][0] == (*g.cur)[sy][sx+1] &&
			from[1][1] == (*g.cur)[sy+1][sx] &&
			from[0][1] == (*g.cur)[sy+1][sx+1]) ||

		(from[0][1] == (*g.cur)[sy][sx] &&
			from[0][0] == (*g.cur)[sy][sx+1] &&
			from[1][1] == (*g.cur)[sy+1][sx] &&
			from[1][0] == (*g.cur)[sy+1][sx+1]) ||
		(from[1][1] == (*g.cur)[sy][sx] &&
			from[0][1] == (*g.cur)[sy][sx+1] &&
			from[1][0] == (*g.cur)[sy+1][sx] &&
			from[0][0] == (*g.cur)[sy+1][sx+1]) ||
		(from[1][0] == (*g.cur)[sy][sx] &&
			from[1][1] == (*g.cur)[sy][sx+1] &&
			from[0][0] == (*g.cur)[sy+1][sx] &&
			from[0][1] == (*g.cur)[sy+1][sx+1]) ||
		(from[0][0] == (*g.cur)[sy][sx] &&
			from[1][0] == (*g.cur)[sy][sx+1] &&
			from[0][1] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1])
}

func (g *Game) Match3x3(from Pattern, sx, sy int) bool {
	return (from[0][0] == (*g.cur)[sy][sx] &&
		from[0][1] == (*g.cur)[sy][sx+1] &&
		from[0][2] == (*g.cur)[sy][sx+2] &&
		from[1][0] == (*g.cur)[sy+1][sx] &&
		from[1][1] == (*g.cur)[sy+1][sx+1] &&
		from[1][2] == (*g.cur)[sy+1][sx+2] &&
		from[2][0] == (*g.cur)[sy+2][sx] &&
		from[2][1] == (*g.cur)[sy+2][sx+1] &&
		from[2][2] == (*g.cur)[sy+2][sx+2]) ||
		(from[0][2] == (*g.cur)[sy][sx] &&
			from[1][2] == (*g.cur)[sy][sx+1] &&
			from[2][2] == (*g.cur)[sy][sx+2] &&
			from[0][1] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1] &&
			from[2][1] == (*g.cur)[sy+1][sx+2] &&
			from[0][0] == (*g.cur)[sy+2][sx] &&
			from[1][0] == (*g.cur)[sy+2][sx+1] &&
			from[2][0] == (*g.cur)[sy+2][sx+2]) ||
		(from[2][2] == (*g.cur)[sy][sx] &&
			from[2][1] == (*g.cur)[sy][sx+1] &&
			from[2][0] == (*g.cur)[sy][sx+2] &&
			from[1][2] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1] &&
			from[1][0] == (*g.cur)[sy+1][sx+2] &&
			from[0][2] == (*g.cur)[sy+2][sx] &&
			from[0][1] == (*g.cur)[sy+2][sx+1] &&
			from[0][0] == (*g.cur)[sy+2][sx+2]) ||
		(from[2][0] == (*g.cur)[sy][sx] &&
			from[1][0] == (*g.cur)[sy][sx+1] &&
			from[0][0] == (*g.cur)[sy][sx+2] &&
			from[2][1] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1] &&
			from[0][1] == (*g.cur)[sy+1][sx+2] &&
			from[2][2] == (*g.cur)[sy+2][sx] &&
			from[1][2] == (*g.cur)[sy+2][sx+1] &&
			from[0][2] == (*g.cur)[sy+2][sx+2]) ||
		(from[0][2] == (*g.cur)[sy][sx] &&
			from[0][1] == (*g.cur)[sy][sx+1] &&
			from[0][0] == (*g.cur)[sy][sx+2] &&
			from[1][2] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1] &&
			from[1][0] == (*g.cur)[sy+1][sx+2] &&
			from[2][2] == (*g.cur)[sy+2][sx] &&
			from[2][1] == (*g.cur)[sy+2][sx+1] &&
			from[2][0] == (*g.cur)[sy+2][sx+2]) ||
		(from[2][2] == (*g.cur)[sy][sx] &&
			from[1][2] == (*g.cur)[sy][sx+1] &&
			from[0][2] == (*g.cur)[sy][sx+2] &&
			from[2][1] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1] &&
			from[0][1] == (*g.cur)[sy+1][sx+2] &&
			from[2][0] == (*g.cur)[sy+2][sx] &&
			from[1][0] == (*g.cur)[sy+2][sx+1] &&
			from[0][0] == (*g.cur)[sy+2][sx+2]) ||
		(from[2][0] == (*g.cur)[sy][sx] &&
			from[2][1] == (*g.cur)[sy][sx+1] &&
			from[2][2] == (*g.cur)[sy][sx+2] &&
			from[1][0] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1] &&
			from[1][2] == (*g.cur)[sy+1][sx+2] &&
			from[0][0] == (*g.cur)[sy+2][sx] &&
			from[0][1] == (*g.cur)[sy+2][sx+1] &&
			from[0][2] == (*g.cur)[sy+2][sx+2]) ||
		(from[0][0] == (*g.cur)[sy][sx] &&
			from[1][0] == (*g.cur)[sy][sx+1] &&
			from[2][0] == (*g.cur)[sy][sx+2] &&
			from[0][1] == (*g.cur)[sy+1][sx] &&
			from[1][1] == (*g.cur)[sy+1][sx+1] &&
			from[2][1] == (*g.cur)[sy+1][sx+2] &&
			from[0][2] == (*g.cur)[sy+2][sx] &&
			from[1][2] == (*g.cur)[sy+2][sx+1] &&
			from[2][2] == (*g.cur)[sy+2][sx+2])
}

func (g *Game) ApplyRulesToSquare(new *Pattern, toOffset, size, sx, sy int) {
	if g.debug {
		fmt.Printf("Checking rules of size %d at %d, %d\n", size, sx, sy)
	}
	for _, r := range g.rules {
		if r.from.Size() != size {
			continue
		}
		if (size == 2 && g.Match2x2(r.from, sx, sy)) ||
			(size == 3 && g.Match3x3(r.from, sx, sy)) {
			if g.debug {
				fmt.Printf("Applying rule:\n%s", r)
			}
			for i, row := range r.to {
				(*new)[toOffset+i] = append((*new)[toOffset+i], row...)
			}
			return
		}
	}
	log.Fatalf("Failed to find match\n")
}

func (g *Game) ApplyRules(size int, toSize int) {
	new := Pattern{}
	toOffset := 0
	for y := 0; y < len(*g.cur); y += size {
		for i := 0; i < toSize; i++ {
			new = append(new, []byte{})
		}
		for x := 0; x < len((*g.cur)[0]); x += size {
			g.ApplyRulesToSquare(&new, toOffset, size, x, y)
		}
		toOffset += toSize
	}
	g.cur = &new
}

func (g *Game) Transform() {
	if (len(*g.cur) % 2) == 0 {
		g.ApplyRules(2, 3)
		return
	}
	g.ApplyRules(3, 4)
}

func (g *Game) Play(n int) int {
	for i := 0; i < n; i++ {
		//fmt.Printf("%s\n", g)
		g.Transform()
	}
	return g.CountOn()
}

func (g *Game) Part1() int {
	return g.Play(5)
}

func (g *Game) Part2() int {
	return g.Play(18)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewGame(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewGame(lines).Part2())
}
