package main

import (
	_ "embed"
	"fmt"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	dep      map[string]map[string]bool
	todo     map[string]bool
	avail    []string
	workload int
	workers  int
	debug    bool
}

func NewGame(lines []string) *Game {
	workload := 60
	workers := 5
	if len(lines) < 10 {
		workload = 0
		workers = 2
	}
	g := &Game{map[string]map[string]bool{}, map[string]bool{}, []string{},
		workload, workers, false}
	for _, line := range lines {
		words := strings.Split(line, " ")
		req := words[1]
		step := words[7]
		if _, ok := g.dep[step]; !ok {
			g.dep[step] = make(map[string]bool)
		}
		g.dep[step][req] = true
		g.todo[step] = true
		g.todo[req] = true
	}
	for k := range g.todo {
		if _, ok := g.dep[k]; !ok {
			g.avail = append(g.avail, k)
		}
	}
	sort.Strings(g.avail)
	return g
}

func (g *Game) Part1() string {

	doWork := func(n string) {
		for k, v := range g.dep {
			delete(v, n)
			if len(v) == 0 {
				delete(g.dep, k)
				g.avail = append(g.avail, k)
				sort.Strings(g.avail)
			}
		}
	}
	s := ""
	for len(g.avail) != 0 {
		var n string
		n, g.avail = g.avail[0], g.avail[1:]
		doWork(n)
		s += n
	}
	return s
}

func (g *Game) Part2() int {
	todo := map[string]int{}
	for k := range g.todo {
		todo[k] = g.workload + int(k[0]) - 64
	}
	doWork := func(n string) bool {
		todo[n]--
		if todo[n] > 0 {
			return false
		}
		delete(todo, n)
		for k, v := range g.dep {
			delete(v, n)
			if len(v) == 0 {
				delete(g.dep, k)
				g.avail = append(g.avail, k)
				sort.Strings(g.avail)
			}
		}
		return true
	}
	t := 0
	doing := make(map[int]string, g.workers)
	for len(g.avail) != 0 || len(doing) != 0 {
		currentWork := g.avail
		for wn := 1; wn <= g.workers; wn++ {
			n := ""
			if _, ok := doing[wn]; ok {
				n = doing[wn]
			} else if len(currentWork) > 0 {
				n, currentWork = currentWork[0], currentWork[1:]
				newAvailableWork := []string{}
				for _, v := range g.avail {
					if v != n {
						newAvailableWork = append(newAvailableWork, v)
					}
				}
				g.avail = newAvailableWork
			} else {
				continue
			}
			doing[wn] = n
			if doWork(n) {
				delete(doing, wn)
			}
		}
		t++
	}
	return t
}

func main() {
	g := NewGame(InputLines(input))
	p1 := g.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	g = NewGame(InputLines(input))
	p2 := g.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
