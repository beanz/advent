package main

import (
	"fmt"
	"log"
	"os"
	"sort"

	. "github.com/beanz/advent-of-code-go"
)

type Component struct {
	in, out int
}

func (c Component) String() string {
	return fmt.Sprintf("%d/%d", c.in, c.out)
}

type sortComponents []Component

func (c sortComponents) Less(i, j int) bool {
	return (c[i].in + c[i].out) > (c[j].in + c[j].out)
}

func (c sortComponents) Swap(i, j int) {
	c[i], c[j] = c[j], c[i]
}

func (c sortComponents) Len() int {
	return len(c)
}

type Game struct {
	comp  []Component
	debug bool
}

func (g *Game) String() string {
	s := ""
	for _, c := range g.comp {
		s += fmt.Sprintf("%s\n", c)
	}
	return s
}

func NewGame(lines []string) *Game {
	g := &Game{[]Component{}, false}
	for _, line := range lines {
		v := SimpleReadInts(line)
		g.comp = append(g.comp, Component{v[0], v[1]})
	}
	sort.Sort(sortComponents(g.comp))
	return g
}

type Search struct {
	used map[Component]bool
	comp []Component
	port int
}

func String(cs []Component) string {
	s := ""
	for _, c := range cs {
		s += fmt.Sprintf("%s ", c)
	}
	return s
}

func Score(comps []Component) int {
	s := 0
	for _, c := range comps {
		s += c.in + c.out
	}
	return s
}

func (g *Game) Play() (int, int) {
	todo := []Search{Search{map[Component]bool{}, []Component{}, 0}}
	best := 0
	longest := 0
	longestLen := 0
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if g.debug {
			fmt.Printf("Cur: %d %s\n", cur.port, String(cur.comp))
		}
		if Score(cur.comp) > best {
			best = Score(cur.comp)
			if g.debug {
				fmt.Printf("New best: %s\n", String(cur.comp))
			}
		}
		if len(cur.comp) > longestLen ||
			(len(cur.comp) == longestLen && Score(cur.comp) > longest) {
			longest = Score(cur.comp)
			longestLen = len(cur.comp)
			if g.debug {
				fmt.Printf("New longest: %s\n", String(cur.comp))
			}
		}
		for _, c := range g.comp {
			if cur.used[c] {
				continue
			}
			switch cur.port {
			case c.in:
				new := Search{map[Component]bool{}, []Component{}, c.out}
				for _, u := range cur.comp {
					new.comp = append(new.comp, u)
					new.used[u] = true
				}
				new.comp = append(new.comp, c)
				new.used[c] = true
				todo = append(todo, new)
			case c.out:
				new := Search{map[Component]bool{}, []Component{}, c.in}
				for _, u := range cur.comp {
					new.comp = append(new.comp, u)
					new.used[u] = true
				}
				new.comp = append(new.comp, c)
				new.used[c] = true
				todo = append(todo, new)
			}
		}
	}
	return best, longest
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	best, longest := NewGame(lines).Play()
	fmt.Printf("Part 1: %d\n", best)
	fmt.Printf("Part 2: %d\n", longest)
}
