package main

import (
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

type Track map[Point]byte

func (t Track) at(p Point) byte {
	if b, ok := t[p]; ok {
		return b
	}
	return ' '
}

type Cart struct {
	dir       byte
	turnCount int
}

func (c Cart) String() string {
	return fmt.Sprintf("%s(%d)", string(c.dir), c.turnCount)
}

type Carts map[Point]*Cart

func (c Carts) addNew(p Point, dir byte) {
	c[p] = &Cart{dir, 0}
}

func (c Carts) addCart(p Point, cart *Cart) {
	c[p] = cart
}

func (c Carts) removeFrom(p Point) {
	delete(c, p)
}

func (c Carts) String() string {
	s := ""
	for p, cart := range c {
		s += fmt.Sprintf("[%d,%d]%s\n", p.X, p.Y, string(cart.dir))
	}
	return s
}

func (c *Cart) move(track Track, p Point) Point {
	nx := p.X
	ny := p.Y
	switch c.dir {
	case '^':
		ny--
	case 'v':
		ny++
	case '<':
		nx--
	case '>':
		nx++
	}
	np := Point{nx, ny}
	nt := track.at(np)
	nd := c.dir
	switch nt {
	case '\\':
		switch c.dir {
		case '>':
			nd = 'v'
		case '^':
			nd = '<'
		case '<':
			nd = '^'
		case 'v':
			nd = '>'
		}
	case '/':
		switch c.dir {
		case '>':
			nd = '^'
		case '^':
			nd = '>'
		case '<':
			nd = 'v'
		case 'v':
			nd = '<'
		}
	case '+':
		switch c.turnCount % 3 {
		case 0:
			switch c.dir {
			case '>':
				nd = '^'
			case '^':
				nd = '<'
			case '<':
				nd = 'v'
			case 'v':
				nd = '>'
			}
		case 2:
			switch c.dir {
			case '>':
				nd = 'v'
			case '^':
				nd = '>'
			case '<':
				nd = '^'
			case 'v':
				nd = '<'
			}
		}
		c.turnCount = (c.turnCount + 1) % 3
	}
	c.dir = nd
	return np
}

func (t Track) String() string {
	bb := NewBoundingBox()
	for p := range t {
		bb.Add(p)
	}
	s := ""
	for y := bb.Min.Y; y <= bb.Max.Y; y++ {
		for x := bb.Min.X; x <= bb.Max.X; x++ {
			s += string(t.at(Point{x, y}))
		}
		s += "\n"
	}
	return s
}

func (t Track) StringWithCarts(carts Carts) string {
	bb := NewBoundingBox()
	for p := range t {
		bb.Add(p)
	}
	s := ""
	for y := bb.Min.Y; y <= bb.Max.Y; y++ {
		for x := bb.Min.X; x <= bb.Max.X; x++ {
			p := Point{x, y}
			if cart, ok := carts[p]; ok {
				s += string(cart.dir)
			} else {
				s += string(t.at(p))
			}
		}
		s += "\n"
	}
	return s
}

type CartOrder []Point

func (s CartOrder) Len() int {
	return len(s)
}

func (s CartOrder) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s CartOrder) Less(i, j int) bool {
	return s[i].Y < s[j].Y || (s[i].Y == s[j].Y && s[i].X < s[j].X)
}

type Game struct {
	carts Carts
	track Track
	todo  []Point
	debug bool
}

func NewGame(lines []string) *Game {
	g := &Game{Carts{}, Track{}, []Point{}, false}
	for y, line := range lines {
		for x := range line {
			sq := line[x]
			p := Point{x, y}
			switch sq {
			case '<':
				g.carts.addNew(p, '<')
				g.todo = append(g.todo, Point{x, y})
				sq = '-'
			case '>':
				g.carts.addNew(p, '>')
				g.todo = append(g.todo, Point{x, y})
				sq = '-'
			case '^':
				g.carts.addNew(p, '^')
				g.todo = append(g.todo, Point{x, y})
				sq = '|'
			case 'v':
				g.carts.addNew(p, 'v')
				g.todo = append(g.todo, Point{x, y})
				sq = '|'
			}
			if sq != ' ' {
				g.track[p] = sq
			}
		}
	}

	return g
}

func (g *Game) Solve(part1 bool) Point {
	for t := 1; true; t++ {
		newTodo := []Point{}
		for _, p := range g.todo {
			cart, ok := g.carts[p]
			if !ok {
				// already crashed this tick
				continue
			}
			np := cart.move(g.track, p)
			if g.debug {
				fmt.Printf("Moving %d, %d => %d, %d\n", p.X, p.Y, np.X, np.Y)
			}
			//fmt.Printf("%v\n", cart)
			g.carts.removeFrom(p)
			if _, ok := g.carts[np]; ok {
				if part1 {
					return np
				}
				g.carts.removeFrom(np)
				continue
			}
			newTodo = append(newTodo, np)
			g.carts.addCart(np, cart)
		}
		//fmt.Println(track.StringWithCarts(carts))
		g.todo = newTodo
		sort.Sort(CartOrder(g.todo))
		if len(g.carts) == 0 {
			return Point{-1, -1}
		}
		if len(g.carts) == 1 {
			for p := range g.carts {
				return p
			}
		}
	}
	return Point{-1, -1}
}

func (g *Game) Part1() string {
	return g.Solve(true).String()
}

func (g *Game) Part2() string {
	return g.Solve(false).String()
}

func main() {
	g := NewGame(ReadInputLines())
	fmt.Printf("Part1: %s\n", g.Part1())
	g = NewGame(ReadInputLines())
	fmt.Printf("Part2: %s\n", g.Part2())
}
