package main

import (
	"fmt"
	"log"
	"os"
	"strconv"

	. "github.com/beanz/advent-of-code-go"
)

type NavInst struct {
	act byte
	val int
}

type Nav struct {
	inst  []NavInst
	ship  Point
	dir   Direction
	wp    Point
	debug bool
}

func NewNav(lines []string) *Nav {
	var inst []NavInst
	for _, line := range lines {
		n, err := strconv.Atoi(line[1:])
		if err != nil {
			log.Fatalf("Invalid line: %s\n", line)
		}
		inst = append(inst, NavInst{act: line[0], val: n})
	}
	return &Nav{
		inst:  inst,
		ship:  Point{X: 0, Y: 0},
		dir:   Direction{Dx: 1, Dy: 0},
		wp:    Point{X: 10, Y: -1},
		debug: false}
}

func (n *Nav) String() string {
	s := ""
	if n.ship.X >= 0 {
		s += fmt.Sprintf("east %d, ", Abs(n.ship.X))
	} else {
		s += fmt.Sprintf("west %d, ", Abs(n.ship.X))
	}
	if n.ship.Y <= 0 {
		s += fmt.Sprintf("north %d", Abs(n.ship.Y))
	} else {
		s += fmt.Sprintf("south %d", Abs(n.ship.Y))
	}
	s += fmt.Sprintf(" d=%s", n.dir)
	return s
}

func (n *Nav) Part1() int {
	if n.debug {
		fmt.Printf("%s\n", n)
	}
	for _, in := range n.inst {
		switch in.act {
		case 'N', 'S', 'E', 'W':
			var dir = Compass(in.act).Direction()
			for i := 0; i < in.val; i++ {
				n.ship = n.ship.In(dir)
			}
		case 'L':
			for i := 0; i < (in.val / 90); i++ {
				n.dir = n.dir.CCW()
			}
		case 'R':
			for i := 0; i < (in.val / 90); i++ {
				n.dir = n.dir.CW()
			}
		case 'F':
			for i := 0; i < in.val; i++ {
				n.ship = n.ship.In(n.dir)
			}
		}
		if n.debug {
			fmt.Printf("%s %c %d\n", n, in.act, in.val)
		}
	}
	return n.ship.ManhattanDistance(Point{X: 0, Y: 0})
}

func (n *Nav) Part2() int {
	if n.debug {
		fmt.Printf("%s\n", n)
	}
	for _, in := range n.inst {
		switch in.act {
		case 'N', 'S', 'E', 'W':
			var dir = Compass(in.act).Direction()
			for i := 0; i < in.val; i++ {
				n.wp = n.wp.In(dir)
			}
		case 'L':
			for i := 0; i < (in.val / 90); i++ {
				n.wp.X, n.wp.Y = n.wp.Y, -1*n.wp.X
			}
		case 'R':
			for i := 0; i < (in.val / 90); i++ {
				n.wp.X, n.wp.Y = -1*n.wp.Y, n.wp.X
			}
		case 'F':
			for i := 0; i < in.val; i++ {
				n.ship.X += n.wp.X
				n.ship.Y += n.wp.Y
			}
		}
		if n.debug {
			fmt.Printf("%s %c %d\n", n, in.act, in.val)
		}
	}
	return n.ship.ManhattanDistance(Point{X: 0, Y: 0})
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewNav(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewNav(lines).Part2())
}
