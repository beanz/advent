package main

import (
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	elves *Circle
	num   int
	debug bool
}

func (g Game) pp() string {
	e := g.elves
	s := ""
	for {
		s += fmt.Sprintf("Elf %d %p\n", e.Num, e)
		e = e.Cw
		if e == g.elves {
			break
		}
	}
	return s
}

func NewGame(num int, debug bool) *Game {
	g := &Game{nil, num, debug}
	g.elves = NewCircle(1)
	cur := g.elves
	for i := 2; i <= g.num; i++ {
		if debug && (i%100) == 0 {
			fmt.Printf("Creating Elf %d\n", i)
		}
		cur = cur.AddNew(i)
	}
	return g
}

func (g Game) Part1() int {
	for g.elves != g.elves.Cw {
		if g.debug {
			fmt.Printf("Elf %d takes Elf %d's presents\n",
				g.elves.Num, g.elves.Cw.Num)
		}
		g.elves.Cw.Remove()
		g.elves = g.elves.Cw
	}
	return g.elves.Num
}

func (g Game) Part2() int {
	num := g.num
	rm := g.elves
	for i := 0; i < num/2; i++ {
		rm = rm.Cw
	}
	for num != 1 {
		if g.debug {
			fmt.Printf("Elf %d takes Elf %d's presents\n",
				g.elves.Num, rm.Num)
		}
		rm.Remove()
		if (num % 2) == 1 {
			rm = rm.Cw
		}
		num--
		rm = rm.Cw
		g.elves = g.elves.Cw
	}
	return g.elves.Num
}

func main() {
	in := ReadInputInts()
	game := NewGame(in[0], false)
	fmt.Printf("Part 1: %d\n", game.Part1())

	game = NewGame(in[0], false)
	fmt.Printf("Part 2: %d\n", game.Part2())
}
