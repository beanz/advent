package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Game struct {
	m     map[Point]byte
	bb    *BoundingBox
	debug bool
}

func (g *Game) String() string {
	s := ""
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		for x := g.bb.Min.X - 1; x <= g.bb.Max.X+1; x++ {
			sq := g.m[Point{x, y}]
			switch sq {
			case '#', '|', '~':
				s += string(sq)
			default:
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func NewGame(lines []string) *Game {
	m := make(map[Point]byte, 10000)
	g := &Game{m, NewBoundingBox(), false}
	for _, line := range lines {
		ints := SimpleReadInts(line)
		if line[0] == 'x' {
			x := ints[0]
			for y := ints[1]; y <= ints[2]; y++ {
				p := Point{x, y}
				g.m[p] = '#'
				g.bb.Add(p)
			}
		} else {
			y := ints[0]
			for x := ints[1]; x <= ints[2]; x++ {
				p := Point{x, y}
				g.m[p] = '#'
				g.bb.Add(p)
			}
		}
	}
	return g
}

func (g *Game) Count(fn func(byte) bool) int {
	c := 0
	for y := g.bb.Min.Y; y <= g.bb.Max.Y; y++ {
		for x := g.bb.Min.X - 1; x <= g.bb.Max.X+1; x++ {
			if fn(g.m[Point{x, y}]) {
				c++
			}
		}
	}
	return c
}

func (g *Game) Solve() {
	todo := []Point{Point{500, 0}}
	seen := map[Point]bool{}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		for y := cur.Y + 1; y <= g.bb.Max.Y; {
			sq := g.m[Point{cur.X, y}]
			if sq == '#' || sq == '~' {
				y--
				if g.debug {
					fmt.Printf("Found new bottom at %d,%d\n", cur.X, y)
				}
				maxX := cur.X
				fill := byte('~')
			LEFT:
				for x := cur.X + 1; x <= g.bb.Max.X+1; x++ {
					sqBelow := g.m[Point{x, y + 1}]
					if sqBelow == 0 || sqBelow == '|' {
						if g.debug {
							fmt.Printf("Found source at %d,%d\n", x, y)
						}
						p := Point{x, y}
						if !seen[p] {
							todo = append(todo, p)
							seen[p] = true
						}
						maxX = x
						fill = '|'
						break LEFT
					}
					if g.m[Point{x, y}] == '#' {
						if g.debug {
							fmt.Printf("Found max at %d,%d\n", x-1, y)
						}
						maxX = x - 1
						break LEFT
					}
				}
				minX := cur.X
			RIGHT:
				for x := cur.X - 1; x >= g.bb.Min.X-1; x-- {
					sqBelow := g.m[Point{x, y + 1}]
					if sqBelow == 0 || sqBelow == '|' {
						if g.debug {
							fmt.Printf("Found source at %d,%d\n", x, y)
						}
						p := Point{x, y}
						if !seen[p] {
							todo = append(todo, p)
							seen[p] = true
						}
						minX = x
						fill = '|'
						break RIGHT
					}
					if g.m[Point{x, y}] == '#' {
						if g.debug {
							fmt.Printf("Found min at %d,%d\n", x+1, y)
						}
						minX = x + 1
						break RIGHT
					}
				}
				for x := minX; x <= maxX; x++ {
					g.m[Point{x, y}] = fill
				}
				y--
				if fill == '|' {
					break
				}
			} else {
				g.m[Point{cur.X, y}] = '|'
			}
			y++
		}
	}
}

func (g *Game) Part1() int {
	g.Solve()
	return g.Count(func(b byte) bool {
		return b == '~' || b == '|'
	})
}

func (g *Game) Part2() int {
	g.Solve()
	return g.Count(func(b byte) bool {
		return b == '~'
	})
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", g.Part1())
	g = NewGame(ReadLines(os.Args[1]))
	fmt.Printf("Part 2: %d\n", g.Part2())
}
