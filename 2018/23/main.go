package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"os"
	"regexp"
	//"sort"
	"strconv"
	"strings"
)

type Point struct {
	x, y, z int
}

func (p Point) String() string {
	return fmt.Sprintf("%d,%d,%d", p.x, p.y, p.z)
}

type Bot struct {
	p Point
	r int
}

func (bot Bot) String() string {
	return fmt.Sprintf("%s~%d", bot.p, bot.r)
}

type BoundingBox struct {
	min Point
	max Point
}

func (bb BoundingBox) String() string {
	return fmt.Sprintf("[%d < %d, %d < %d, %d < %d]",
		bb.min.x, bb.max.x, bb.min.y, bb.max.y, bb.min.z, bb.max.z)
}

func (bb BoundingBox) Size() Point {
	return Point{bb.max.x - bb.min.x,
		bb.max.y - bb.min.y,
		bb.max.z - bb.min.z}
}

type Game struct {
	bots []*Bot
	bb   BoundingBox
	max  *Bot
}

func (g *Game) String() string {
	return fmt.Sprintf("%s #%d", g.bb, len(g.bots))
}

func readInput(file string) (*Game, error) {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		return nil, err
	}
	return readGame(string(b)), nil
}

func readGame(input string) *Game {
	lineRe :=
		regexp.MustCompile(`pos=<([^,]+),([^,]+),([^>]+)>, r=(\d+)`)
	bots := []*Bot{}

	bb := BoundingBox{Point{math.MaxInt64, math.MaxInt64, math.MaxInt64},
		Point{math.MinInt64, math.MinInt64, math.MinInt64}}

	rMax := math.MinInt64
	var botMax *Bot
	lines := strings.Split(input, "\n")
	for _, line := range lines[:len(lines)-1] {
		m := lineRe.FindStringSubmatch(line)
		if m == nil {
			log.Fatalf("invalid line:\n%s\n", line)
		}
		x, err := strconv.Atoi(m[1])
		if err != nil {
			log.Fatalf("invalid x in line:\n%s\n", line)
		}
		y, err := strconv.Atoi(m[2])
		if err != nil {
			log.Fatalf("invalid y in line:\n%s\n", line)
		}
		z, err := strconv.Atoi(m[3])
		if err != nil {
			log.Fatalf("invalid z in line:\n%s\n", line)
		}
		r, err := strconv.Atoi(m[4])
		if err != nil {
			log.Fatalf("invalid r in line:\n%s\n", line)
		}
		b := &Bot{Point{int(x), int(y), int(z)}, int(r)}
		bots = append(bots, b)
		if r > rMax {
			rMax = r
			botMax = b
		}
		if int(x) < bb.min.x {
			bb.min.x = int(x)
		}
		if int(y) < bb.min.y {
			bb.min.y = int(y)
		}
		if int(z) < bb.min.z {
			bb.min.z = int(z)
		}
		if int(x) > bb.max.x {
			bb.max.x = int(x)
		}
		if int(y) > bb.max.y {
			bb.max.y = int(y)
		}
		if int(z) > bb.max.z {
			bb.max.z = int(z)
		}

	}
	fmt.Printf("Parsed %d bots\n", len(bots))
	return &Game{bots, bb, botMax}
}

func manhattanDist(p1, p2 Point) int {
	diffx := math.Abs(float64(p1.x) - float64(p2.x))
	diffy := math.Abs(float64(p1.y) - float64(p2.y))
	diffz := math.Abs(float64(p1.z) - float64(p2.z))
	return int(diffx + diffy + diffz)
}

func inRange(bot *Bot, p Point) bool {
	return manhattanDist(p, bot.p) <= bot.r
}

func play1(g *Game) int {
	c := 0
	for _, bot := range g.bots {
		if inRange(g.max, bot.p) {
			c++
		}
	}
	return c
}

func startingScale(g *Game) int {
	var scale int = 1
	size := g.bb.Size()
	for size.x/scale > 64 ||
		size.y/scale > 64 ||
		size.z/scale > 64 {
		scale *= 2
	}
	return scale
}

func scaleV(v int, scale int) int {
	return int(math.Round(float64(v) / float64(scale)))
}

func scaleGame(g *Game, scale int) *Game {
	bots := []*Bot{}
	bb := BoundingBox{
		Point{scaleV(g.bb.min.x, scale),
			scaleV(g.bb.min.y, scale),
			scaleV(g.bb.min.z, scale)},
		Point{scaleV(g.bb.max.x, scale),
			scaleV(g.bb.max.y, scale),
			scaleV(g.bb.max.z, scale)},
	}
	for _, bot := range g.bots {
		b := &Bot{Point{scaleV(bot.p.x, scale),
			scaleV(bot.p.y, scale),
			scaleV(bot.p.z, scale)},
			scaleV(bot.r, scale)}
		bots = append(bots, b)
	}
	return &Game{bots, bb, nil}
}

func countInRange(bots []*Bot, p Point) int {
	c := 0
	for _, bot := range bots {
		if manhattanDist(p, bot.p) <= bot.r {
			c++
		}
	}
	return c
}

func best(sg *Game, bb BoundingBox) []Point {
	best := []Point{}
	min := len(sg.bots) - 1
	for z := bb.min.z; z <= bb.max.z; z++ {
		fmt.Printf("z=%d   \r", z)
		for y := bb.min.y; y <= bb.max.y; y++ {
			for x := bb.min.x; x <= bb.max.x; x++ {
				cur := Point{x, y, z}
				missingCount := len(sg.bots) - countInRange(sg.bots, cur)
				if missingCount == min {
					best = append(best, cur)
				} else if missingCount < min {
					fmt.Printf("New best %s, missing %d\n", cur, missingCount)
					best = []Point{cur}
					min = missingCount
				}
			}
		}
	}
	fmt.Printf("\n")
	return best
}

func newBoundingBox(best []Point) BoundingBox {
	bb := BoundingBox{Point{math.MaxInt64, math.MaxInt64, math.MaxInt64},
		Point{math.MinInt64, math.MinInt64, math.MinInt64}}
	for _, p := range best {
		x := p.x * 2
		if x-2 < bb.min.x {
			bb.min.x = x - 2
		}
		if x+2 > bb.max.x {
			bb.max.x = x + 2
		}
		y := p.y * 2
		if y-2 < bb.min.y {
			bb.min.y = y - 2
		}
		if y+2 > bb.max.y {
			bb.max.y = y + 2
		}
		z := p.z * 2
		if z-2 < bb.min.z {
			bb.min.z = z - 2
		}
		if z+2 > bb.max.z {
			bb.max.z = z + 2
		}
	}
	return bb
}

func play2(g *Game) int {
	scale := startingScale(g)
	fmt.Printf("Starting scale: %d\n", scale)
	scaled := scaleGame(g, scale)
	bb := BoundingBox{
		Point{scaled.bb.min.x, scaled.bb.min.y, scaled.bb.min.z},
		Point{scaled.bb.max.x, scaled.bb.max.y, scaled.bb.max.z},
	}
	var bestest []Point
	for {
		fmt.Printf("Scale: %d, Bounding box: %s\n", scale, bb)
		bestest = best(scaled, bb)
		if scale == 1 {
			break
		}
		scale /= 2
		scaled = scaleGame(g, scale)
		bb = newBoundingBox(bestest)
	}
	return int(manhattanDist(Point{0, 0, 0}, bestest[0]))
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game, err := readInput(input)
	if err != nil {
		log.Fatalf("error reading input: %s\n", err)
	}
	fmt.Printf("%s\n", game)

	res := play1(game)
	fmt.Printf("Part 1: %d\n", res)

	res = play2(game)
	fmt.Printf("Part 2: %d\n", res)
}
