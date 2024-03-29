package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	p1    []int
	p2    []int
	debug bool
}

type Player byte

const (
	Player1 Player = iota
	Player2
)

func NewGame(in []string) *Game {
	p1 := SimpleReadInts(in[0])
	p2 := SimpleReadInts(in[1])
	return &Game{p1[1:], p2[1:], DEBUG()}
}

func Score(d []int) int {
	s := 0
	for i := 1; i <= len(d); i++ {
		s += (1 + len(d) - i) * d[i-1]
	}
	return s
}

func Key(d1, d2 []int) int {
	return Score(d1) * Score(d2)
}

func DS(d []int) string {
	s := ""
	for _, c := range d {
		s += fmt.Sprintf("%02x", c)
	}
	return s
}

func (g *Game) Combat(d1, d2 []int, part2 bool) (Player, []int) {
	seen := make(map[int]bool)
	round := 1
	for len(d1) > 0 && len(d2) > 0 {
		if g.debug {
			fmt.Printf("%d: d1=%s d2=%s\n", round, DS(d1), DS(d2))
		}
		k := Key(d1, d2)
		if seen[k] {
			if g.debug {
				fmt.Printf("%d: p1! (seen)\n", round)
			}
			return Player1, d1
		}
		seen[k] = true
		var c1 int
		var c2 int
		var winner Player
		c1, d1 = d1[0], d1[1:]
		c2, d2 = d2[0], d2[1:]
		if g.debug {
			fmt.Printf("%d: c1=%d c2=%d\n", round, c1, c2)
		}
		if part2 && len(d1) >= c1 && len(d2) >= c2 {
			nd1 := make([]int, c1)
			copy(nd1, d1)
			nd2 := make([]int, c2)
			copy(nd2, d2)
			if g.debug {
				fmt.Printf("%d: subgame\n", round)
			}
			winner, _ = g.Combat(nd1, nd2, true)
		} else {
			if c1 > c2 {
				winner = Player1
			} else {
				winner = Player2
			}
		}
		if winner == Player1 {
			if g.debug {
				fmt.Printf("%d: p1!\n", round)
			}
			d1 = append(d1, c1, c2)
		} else {
			if g.debug {
				fmt.Printf("%d: p2!\n", round)
			}
			d2 = append(d2, c2, c1)
		}
		round++
	}
	if len(d1) > 0 {
		if g.debug {
			fmt.Printf("p1!\n")
		}
		return Player1, d1
	}
	if g.debug {
		fmt.Printf("p2!\n")
	}
	return Player2, d2
}

func (g *Game) Play(part2 bool) int {
	_, d := g.Combat(g.p1, g.p2, part2)
	return Score(d)
}

func (g *Game) Part1() int {
	return g.Play(false)
}

func (g *Game) Part2() int {

	return g.Play(true)
}

func main() {
	chunks := InputChunks(input)
	g := NewGame(chunks)
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
