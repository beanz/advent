package main

import (
	"fmt"
	"io/ioutil"
	"log"
	//"math"
	"os"
	//"regexp"
	"sort"
	//"strconv"
	"strings"
)

func readLines(file string) ([]string, error) {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		return nil, err
	}
	lines := strings.Split(string(b), "\n")
	return lines[:len(lines)-1], nil
}

type Player struct {
	x, y    int
	kind    rune
	hp, pwr int
}

func (p Player) IsEnemy(e *Player) bool {
	return p.kind != e.kind
}

func (p Player) Less(p1 *Player) bool {
	return p.y < p1.y || (p.y == p1.y && p.x < p1.x)
}

type Players []*Player

func (p Players) Len() int {
	return len(p)
}

func (p Players) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func (p Players) Less(i, j int) bool {
	return p[i].Less(p[j])
}

type Enemies []*Player

func (p Enemies) Len() int {
	return len(p)
}

func (p Enemies) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func (p Enemies) Less(i, j int) bool {
	return p[i].hp < p[j].hp ||
		(p[i].hp == p[j].hp && Player(*p[i]).Less(p[j]))
}

type Location struct {
	x, y int
}

type StartEnd struct {
	s, e Location
}

type Attack struct {
	s Location
	p *Player
}

type Attacks []Attack

func (a Attacks) Len() int {
	return len(a)
}

func (a Attacks) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}

func (a Attacks) Less(i, j int) bool {
	return a[i].p.Less(a[j].p)
}

type Alive map[rune]int

type Game struct {
	h, w    int
	players Players
	m       []string
	alive   Alive
}

func readGame(lines []string, elfAttack int) Game {
	g := Game{len(lines), len(lines[0]),
		[]*Player{}, []string{}, make(map[rune]int, 2)}
	for y, line := range lines {
		m := ""
		for x, rune := range line {
			switch rune {
			case '#', '.':
				m += string(rune)
			case 'G', 'E':
				g.alive[rune]++
				m += string('.')
				attack := 3
				if rune == 'E' {
					attack = elfAttack
				}
				g.players = append(g.players, &Player{x, y, rune, 200, attack})
			}
		}
		g.m = append(g.m, m)
	}
	return g
}

func playerAt(players []*Player, x, y int) (*Player, bool) {
	for _, p := range players {
		if p.x == x && p.y == y && p.hp > 0 {
			return p, true
		}
	}
	return nil, false
}

func red(s string) string {
	return "\033[31m" + s + "\033[37m"
}

func green(s string) string {
	return "\033[32m" + s + "\033[37m"
}

func clear() string {
	return "\033[3J\033[H\033[2J"
}

func stringAt(s string, x, y int) string {
	return fmt.Sprintf("\033[%d;%dH%s\033[33;1H", y+1, x+1, s)
}

func pretty(g Game) string {
	s := ""
	for y := 0; y < g.h; y++ {
		hp := []int{}
		for x := 0; x < g.w; x++ {
			if p, ok := playerAt(g.players, x, y); ok {
				s += string(p.kind)
				hp = append(hp, p.hp)
			} else {
				s += string(g.m[y][x])
			}
		}
		for _, v := range hp {
			s += " " + fmt.Sprintf("%d", v)
		}
		s += "\n"
	}
	return s
}

func target(g Game, p *Player) (*Player, bool) {
	return targetAt(g, p, Location{p.x, p.y})
}

func targetAt(g Game, p *Player, l Location) (*Player, bool) {
	enemies := Players{}
	if e, ok := playerAt(g.players, l.x, l.y-1); ok && p.IsEnemy(e) {
		enemies = append(enemies, e)
	}
	if e, ok := playerAt(g.players, l.x-1, l.y); ok && p.IsEnemy(e) {
		enemies = append(enemies, e)
	}
	if e, ok := playerAt(g.players, l.x+1, l.y); ok && p.IsEnemy(e) {
		enemies = append(enemies, e)
	}
	if e, ok := playerAt(g.players, l.x, l.y+1); ok && p.IsEnemy(e) {
		enemies = append(enemies, e)
	}
	if len(enemies) == 0 {
		return nil, false
	}
	sort.Sort(Enemies(enemies))
	return enemies[0], true
}

func attack(g Game, p *Player, e *Player) {
	//fmt.Printf("  %s at %d,%d attacks %d,%d\n",
	//	string(p.kind), p.x, p.y, e.x, e.y)
	//fmt.Println(stringAt(green(string(p.kind)), p.x, p.y) +
	//	stringAt(red(string(e.kind)), e.x, e.y))
	e.hp -= p.pwr
	if e.hp <= 0 {
		g.alive[e.kind]--
	}
}

func mapAt(g Game, x, y int) byte {
	return g.m[y][x]
}

func emptyAdjacent(g Game, x, y int) []Location {
	res := []Location{}
	for _, l := range []Location{Location{x, y - 1}, Location{x - 1, y},
		Location{x + 1, y}, Location{x, y + 1}} {
		if mapAt(g, l.x, l.y) == '.' {
			if _, ok := playerAt(g.players, l.x, l.y); !ok {
				res = append(res, l)
			}
		}
	}
	return res
}

func checkVisited(v map[int]map[int]bool, l Location) bool {
	if _, ok := v[l.y]; !ok {
		v[l.y] = make(map[int]bool)
	}
	if _, ok := v[l.y][l.x]; ok {
		return true
	}
	v[l.y][l.x] = true
	return false
}

func move(g Game, p *Player) bool {
	todo := []StartEnd{}
	for _, l := range emptyAdjacent(g, p.x, p.y) {
		todo = append(todo, StartEnd{l, l})
	}
	visited := make(map[Location]bool)
	found := []Attack{}
	for len(todo) > 0 {
		newTodo := []StartEnd{}
		for _, se := range todo {
			l := se.e
			if e, ok := targetAt(g, p, l); ok {
				found = append(found, Attack{se.s, e})
			}
			for _, newL := range emptyAdjacent(g, l.x, l.y) {
				if !visited[newL] {
					newTodo = append(newTodo, StartEnd{se.s, newL})
					visited[newL] = true
				}
			}
		}
		todo = newTodo
		if len(found) > 0 {
			break
		}
	}
	if len(found) > 0 {
		sort.Sort(Attacks(found))
		//fmt.Printf("%s at %d,%d moves to %d,%d\n",
		//	string(p.kind), p.x, p.y, found[0].s.x, found[0].s.y)
		//fmt.Println(stringAt(string(p.kind), found[0].s.x, found[0].s.y) +
		//	stringAt(".", p.x, p.y))
		p.x, p.y = found[0].s.x, found[0].s.y
	}

	return false
}

func turnFor(g Game, p *Player) {
	//fmt.Printf("turnFor %s at %d,%d\n", string(p.kind), p.x, p.y)
	if e, ok := target(g, p); ok {
		attack(g, p, e)
		return
	}
	move(g, p)
	if e, ok := target(g, p); ok {
		attack(g, p, e)
		return
	}
}

func play(lines []string, elfAttack int) int {
	g := readGame(lines, elfAttack)
	//fmt.Println(pretty(g))
	round := 1
	allElves := g.alive['E']
	for {
		todo := g.players
		sort.Sort(Players(todo))
		for _, player := range todo {
			if player.hp <= 0 {
				continue
			}
			if elfAttack != 3 {
				if g.alive['E'] != allElves {
					return -1
				}
			}
			if g.alive['E']*g.alive['G'] == 0 {
				hp := 0
				for _, p := range g.players {
					if p.hp > 0 {
						hp += p.hp
					}
				}
				round-- // previous round is last full round
				//fmt.Printf("%d * %d = %d\n", round, hp, round*hp)
				return round * hp
			}
			turnFor(g, player)
		}
		//fmt.Printf("\nRound %d\n", round)
		//fmt.Println(pretty(g))
		round++
	}
}

func play1(lines []string) int {
	return play(lines, 3)
}

func play2(lines []string) int {
	elfAttack := 4
	for {
		res := play(lines, elfAttack)
		if res != -1 {
			return res
		}
		elfAttack++
	}
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	lines, err := readLines(input)
	if err != nil {
		log.Fatalf("failed to read input %s: %s\n", input, err)
	}

	//fmt.Printf("%#v\n", strings.Split(strings.Replace(pretty(readGame(lines, 3)), " 200", "", 1000), "\n"))

	res := play1(lines)
	fmt.Printf("Part 1: %d\n", res)

	res = play2(lines)
	fmt.Printf("Part 2: %d\n", res)
}