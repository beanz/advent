package main

import (
	"fmt"
	"log"
	"math"
	"os"

	. "github.com/beanz/advent-of-code-go"
)

type Game struct {
	serial  int
	sizeMin int
	sizeMax int
	gridMin Point
	gridMax Point
	cache   map[Square]int
	debug   bool
}

func NewGame(lines []string) *Game {
	serial := SimpleReadInts(lines[0])[0]
	size := SimpleReadInts(lines[1])
	gridMin := SimpleReadInts(lines[2])
	gridMax := SimpleReadInts(lines[3])
	return &Game{serial, size[0], size[1],
		Point{gridMin[0], gridMin[1]}, Point{gridMax[0], gridMax[1]},
		map[Square]int{}, false}
}

func (g *Game) String() string {
	return fmt.Sprintf("serial: %d size: %d-%d grid: %d-%d, %d-%d",
		g.serial, g.sizeMin, g.sizeMax,
		g.gridMin.X, g.gridMax.X, g.gridMin.Y, g.gridMax.Y)
}

func (g *Game) Level(point Point) int {
	r := point.X + 10
	p := r * point.Y
	p += g.serial
	p *= r
	p /= 100
	p %= 10
	return p - 5
}

type Square struct {
	p    Point
	size int
}

func (g *Game) LevelSquare(sq Square) int {
	if l, ok := g.cache[sq]; ok {
		return l
	}
	var ok bool
	l := 0
	if l, ok = g.cache[Square{sq.p, sq.size}]; ok {
		// right edge
		for j := 0; j < sq.size; j++ {
			l += g.Level(Point{sq.p.X + sq.size - 1, sq.p.Y + j})
		}
		// bottom edge (without right most square)
		for i := 0; i < sq.size-1; i++ {
			l += g.Level(Point{sq.p.X + i, sq.p.Y + sq.size - 1})
		}
	} else {
		// left edge
		for j := 0; j < sq.size; j++ {
			l += g.Level(Point{sq.p.X, sq.p.Y + j})
		}
		// top edge (without left most square)
		for i := 1; i < sq.size; i++ {
			l += g.Level(Point{sq.p.X + i, sq.p.Y})
		}
		if sq.size > 1 {
			l += g.LevelSquare(Square{Point{sq.p.X + 1, sq.p.Y + 1},
				sq.size - 1})
		}
	}
	g.cache[sq] = l
	return l
}

func (sq Square) String() string {
	return fmt.Sprintf("%d,%d,%d", sq.p.X, sq.p.Y, sq.size)
}

func (g *Game) Solve() (Square, int) {
	var maxSq Square
	max := math.MinInt64
	for size := g.sizeMin; size <= g.sizeMax; size++ {
		for x := g.gridMin.X; x <= g.gridMax.X-size+1; x++ {
			if g.debug {
				fmt.Printf("%3d %3d\r", size, x)
			}
			for y := g.gridMin.Y; y <= g.gridMax.Y-size+1; y++ {
				sq := Square{Point{x, y}, size}
				l := g.LevelSquare(sq)
				if l > max {
					max = l
					maxSq = sq
				}
			}
		}
	}

	return maxSq, max
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	g := NewGame(ReadLines(os.Args[1]))
	sq, level := g.Solve()
	fmt.Printf("Result: %s (%d)\n", sq, level)
}
