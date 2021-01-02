package main

import (
	"crypto/md5"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	h, w     int
	passcode string
	debug    bool
}

func (g *Game) Code(path string) map[rune]bool {
	r := map[rune]bool{}
	charToDir := map[int]rune{}
	charToDir[0] = 'U'
	charToDir[1] = 'D'
	charToDir[2] = 'L'
	charToDir[3] = 'R'
	sum := fmt.Sprintf("%x", md5.Sum([]byte(g.passcode+path)))
	for i, dir := range charToDir {
		if sum[i] == 'b' || sum[i] == 'c' || sum[i] == 'd' ||
			sum[i] == 'e' || sum[i] == 'f' {
			r[dir] = true
		}
	}
	return r
}

func (g *Game) Neighbours(path string, p Point) map[rune]Point {
	code := g.Code(path)
	n := map[rune]Point{}
	if p.Y > 0 && code['U'] {
		n['U'] = Point{p.X, p.Y - 1}
	}
	if p.X > 0 && code['L'] {
		n['L'] = Point{p.X - 1, p.Y}
	}
	if p.X < g.w-1 && code['R'] {
		n['R'] = Point{p.X + 1, p.Y}
	}
	if p.Y < g.h-1 && code['D'] {
		n['D'] = Point{p.X, p.Y + 1}
	}
	return n
}

type Search struct {
	p    Point
	path string
}

func (g Game) Play(part2 bool) string {
	todo := []Search{Search{Point{0, 0}, ""}}
	longest := ""
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if g.debug {
			fmt.Printf("Checking [%d,%d] %s\n", cur.p.X, cur.p.Y, cur.path)
		}
		if cur.p.X == (g.w-1) && cur.p.Y == (g.h-1) {
			if g.debug {
				fmt.Printf("Found solution %s\n", cur.path)
			}
			if !part2 {
				return cur.path
			}
			if len(cur.path) > len(longest) {
				longest = cur.path
			}
			continue
		}
		for dir, np := range g.Neighbours(cur.path, cur.p) {
			if g.debug {
				fmt.Printf("  door %s to %d,%d\n", string(dir), np.X, np.Y)
			}
			todo = append(todo, Search{np, cur.path + string(dir)})
		}
	}
	return longest
}

func (g Game) Part1() string {
	return g.Play(false)
}

func (g Game) Part2() int {
	return len(g.Play(true))
}

func main() {
	in := ReadInputLines()
	game := Game{4, 4, in[0], false}
	fmt.Printf("Part 1: %s\n", game.Part1())
	fmt.Printf("Part 2: %d\n", game.Part2())
}
