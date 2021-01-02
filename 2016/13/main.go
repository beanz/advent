package main

import (
	"fmt"
	"log"
	"math/bits"
	"os"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	fav    int
	target Point
}

func (g Game) WhatsThere(p Point) string {
	s := p.X*p.X + 3*p.X + 2*p.X*p.Y + p.Y + p.Y*p.Y
	s += int(g.fav)
	if (bits.OnesCount(uint(s)) % 2) == 0 {
		return "."
	}
	return "#"
}

type Search struct {
	p     Point
	moves int
}

func (g Game) Part1() int {
	todo := []Search{Search{Point{1, 1}, 0}}
	visited := map[Point]bool{}
	best := 10000000
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if visited[cur.p] {
			continue
		}
		visited[cur.p] = true
		if cur.p.X == g.target.X && cur.p.Y == g.target.Y {
			//fmt.Printf("Found solution in %d moves\n", cur.moves)
			if cur.moves < best {
				best = cur.moves
			}
		}
		if cur.moves > best {
			continue
		}
		for _, n := range cur.p.Neighbours() {
			if n.X < 0 || n.Y < 0 {
				continue
			}

			if g.WhatsThere(n) == "." {
				todo = append(todo, Search{n, cur.moves + 1})
			}
		}
	}
	return best
}

func (g Game) Part2() int {
	todo := []Search{Search{Point{1, 1}, 0}}
	visited := map[Point]bool{}
	count := 0
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if visited[cur.p] {
			continue
		}
		visited[cur.p] = true
		count++
		if cur.moves == 50 {
			continue
		}
		for _, n := range cur.p.Neighbours() {
			if n.X < 0 || n.Y < 0 {
				continue
			}
			if g.WhatsThere(n) == "." {
				todo = append(todo, Search{n, cur.moves + 1})
			}
		}
	}
	return count
}

func main() {
	if len(os.Args) < 3 {
		log.Fatalf("Usage: %s <input> targetx,targety\n", os.Args[0])
	}
	input, err := strconv.Atoi(os.Args[1])
	if err != nil {
		log.Fatalf("error parsing argument: %s\n", err)
	}
	xy := strings.Split(os.Args[2], ",")
	x, err := strconv.Atoi(xy[0])
	if err != nil {
		log.Fatalf("error parsing argument: %s\n", err)
	}
	y, err := strconv.Atoi(xy[1])
	if err != nil {
		log.Fatalf("error parsing argument: %s\n", err)
	}
	game := Game{input, Point{x, y}}
	res := game.Part1()
	fmt.Printf("Part 1: %d\n", res)

	res = game.Part2()
	fmt.Printf("Part 2: %d\n", res)
}
