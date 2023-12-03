package main

import (
	_ "embed"
	"fmt"
	"math"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game1 int

func NewGame1(lines []string) Game1 {
	m := strings.Join(lines, "")
	var n Game1
	for i := 0; i < len(m); i++ {
		if m[i] == '#' {
			n += 1 << i
		}
	}
	return n
}

func (g Game1) bug(x int, y int) bool {
	if x < 0 || x > 4 || y < 0 || y > 4 {
		return false
	}
	return (g & (1 << (y*5 + x))) != 0
}

func (g Game1) String() string {
	s := ""
	for y := 0; y < 5; y++ {
		for x := 0; x < 5; x++ {
			if g.bug(x, y) {
				s += "#"
			} else {
				s += "."
			}
		}
		s += "\n"
	}
	return s
}

func (g Game1) life(x int, y int) bool {
	c := 0
	if g.bug(x, y-1) {
		c++
	}
	if g.bug(x-1, y) {
		c++
	}
	if g.bug(x+1, y) {
		c++
	}
	if g.bug(x, y+1) {
		c++
	}
	return c == 1 || (!g.bug(x, y) && c == 2)
}

func (g Game1) Part1() int {
	seen := make(map[Game1]bool)
	for {
		var new Game1
		for y := 0; y < 5; y++ {
			for x := 0; x < 5; x++ {
				if g.life(x, y) {
					new += 1 << (y*5 + x)
				}
			}
		}
		if _, ok := seen[new]; ok {
			return int(new)
		}
		seen[new] = true
		g = new
	}
}

type Game2 map[int]int

func NewGame2(lines []string) Game2 {
	m := strings.Join(lines, "")
	n := 0
	for i := 0; i < len(m); i++ {
		if m[i] == '#' {
			n += 1 << i
		}
	}
	g := make(Game2, 50)
	g[0] = n
	return g
}

func (g Game2) bug(d int, x int, y int) bool {
	if x < 0 || x > 4 || y < 0 || y > 4 {
		return false
	}
	return (g[d] & (1 << (y*5 + x))) != 0
}

func (g Game2) String() string {
	depths := make([]int, 0, len(g))
	for k := range g {
		depths = append(depths, k)
	}
	sort.Ints(depths)
	s := ""
	for _, depth := range depths {
		s += fmt.Sprintf("Depth %d\n%d\n", depth, g[depth])
		for y := 0; y < 5; y++ {
			for x := 0; x < 5; x++ {
				if x == 2 && y == 2 {
					s += "?"
				} else if g.bug(depth, x, y) {
					s += "#"
				} else {
					s += "."
				}
			}
			s += "\n"
		}
		s += "\n"
	}
	return s
}

func (g Game2) count() int {
	c := 0
	for depth := range g {
		for y := 0; y < 5; y++ {
			for x := 0; x < 5; x++ {
				if !(x == 2 && y == 2) && g.bug(depth, x, y) {
					c++
				}
			}
		}
	}
	return c
}

type Neighbour struct {
	d int
	x int
	y int
}

func neighbours(d int, x int, y int) []Neighbour {
	neighbours := []Neighbour{}
	// neighbour(s) above
	if y == 0 {
		neighbours = append(neighbours, Neighbour{d - 1, 2, 1})
	} else if y == 3 && x == 2 {
		for i := 0; i < 5; i++ {
			neighbours = append(neighbours, Neighbour{d + 1, i, 4})
		}
	} else {
		neighbours = append(neighbours, Neighbour{d, x, y - 1})
	}

	// neighbour(s) below
	if y == 4 {
		neighbours = append(neighbours, Neighbour{d - 1, 2, 3})
	} else if y == 1 && x == 2 {
		for i := 0; i < 5; i++ {
			neighbours = append(neighbours, Neighbour{d + 1, i, 0})
		}
	} else {
		neighbours = append(neighbours, Neighbour{d, x, y + 1})
	}

	// neighbour(s) left
	if x == 0 {
		neighbours = append(neighbours, Neighbour{d - 1, 1, 2})
	} else if x == 3 && y == 2 {
		for i := 0; i < 5; i++ {
			neighbours = append(neighbours, Neighbour{d + 1, 4, i})
		}
	} else {
		neighbours = append(neighbours, Neighbour{d, x - 1, y})
	}

	// neighbour(s) right
	if x == 4 {
		neighbours = append(neighbours, Neighbour{d - 1, 3, 2})
	} else if x == 1 && y == 2 {
		for i := 0; i < 5; i++ {
			neighbours = append(neighbours, Neighbour{d + 1, 0, i})
		}
	} else {
		neighbours = append(neighbours, Neighbour{d, x + 1, y})
	}

	return neighbours
}

func (g Game2) life(d int, x int, y int) bool {
	c := 0
	for _, nb := range neighbours(d, x, y) {
		if g.bug(nb.d, nb.x, nb.y) {
			c++
		}
	}
	return c == 1 || (!g.bug(d, x, y) && c == 2)
}

func (g Game2) Part2(min int) int {
	for m := 0; m < min; m++ {
		minDepth := math.MaxInt32
		maxDepth := math.MinInt32
		for k := range g {
			if k > maxDepth {
				maxDepth = k
			}
			if k < minDepth {
				minDepth = k
			}
		}
		ng := make(Game2, len(g))
		for depth := minDepth - 1; depth <= maxDepth+1; depth++ {
			new := 0
			for y := 0; y < 5; y++ {
				for x := 0; x < 5; x++ {
					if x == 2 && y == 2 {
						continue
					}
					if g.life(depth, x, y) {
						new += 1 << (y*5 + x)
					}
				}
			}
			ng[depth] = new
		}
		g = ng
		//fmt.Printf("%s%d\n", g, g.count())
	}
	return g.count()
}

func main() {
	lines := InputLines(input)
	p1 := NewGame1(lines).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewGame2(lines).Part2(200)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
