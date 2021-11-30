package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"time"

	. "github.com/beanz/advent/lib-go"
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
	scale uint
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
		scale: 1,
		debug: DEBUG(),
	}
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

func (n *Nav) Draw(part2 bool) {
	if !VISUAL() {
		return
	}
	col, row := Screen()
	s := ClearScreen()
	sx := n.ship.X / int(n.scale)
	sy := n.ship.Y / int(n.scale)
	if Abs(sx) > col/2 || Abs(sy) > row/2 {
		n.scale++
		n.Draw(part2)
		return
	}
	wx := (n.ship.X + n.wp.X) / int(n.scale)
	wy := (n.ship.Y + n.wp.Y) / int(n.scale)
	if Abs(wx) > col/2 || Abs(wy) > row/2 {
		n.scale++
		n.Draw(part2)
		return
	}
	s += fmt.Sprintf("%s%c", CursorTo(col/2, row/2), 'O')
	if part2 {
		s += fmt.Sprintf("%s%c", CursorTo(col/2+wx, row/2+wy), 'W')
	}
	s += fmt.Sprintf("%s%c", CursorTo(col/2+sx, row/2+sy), n.dir.Char())
	fmt.Print(s + "\n")
	time.Sleep(20 * time.Millisecond)
}

func (n *Nav) Clear() {
	if !VISUAL() {
		return
	}
	fmt.Print(ClearScreen())
}

func (n *Nav) End() {
	if !VISUAL() {
		return
	}
	_, row := Screen()
	fmt.Print(CursorTo(0, row-3))
}

func (n *Nav) Part1() int {
	n.Clear()
	if n.debug {
		fmt.Printf("%s\n", n)
	}
	n.Draw(false)
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
		n.Draw(false)
	}
	n.End()
	return n.ship.ManhattanDistance(Point{X: 0, Y: 0})
}

func (n *Nav) Part2() int {
	n.Clear()
	n.Draw(true)
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
		n.Draw(true)
	}
	n.End()
	return n.ship.ManhattanDistance(Point{X: 0, Y: 0})
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	p1 := NewNav(lines).Part1()
	p2 := NewNav(lines).Part2()
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
