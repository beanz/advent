package main

import (
	_ "embed"
	"fmt"
	"math"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Routes struct {
	r        map[string]map[string]int
	p        []string
	min, max int
}

func NewRoutes(in []string) *Routes {
	r := make(map[string]map[string]int, len(in)*2)
	p := []string{}
	for _, l := range in {
		es := strings.Split(l, " = ")
		dist := MustParseInt(es[1])
		places := strings.Split(es[0], " to ")
		if _, ok := r[places[0]]; !ok {
			r[places[0]] = make(map[string]int)
			p = append(p, places[0])
		}
		r[places[0]][places[1]] = dist
		if _, ok := r[places[1]]; !ok {
			r[places[1]] = make(map[string]int)
			p = append(p, places[1])
		}
		r[places[1]][places[0]] = dist
	}
	routes := &Routes{r: r, p: p}
	routes.Calc()
	return routes
}

func (r *Routes) Calc() {
	min := math.MaxInt32
	max := math.MinInt32
	perms := NewPerms(len(r.p))
	for perm := perms.Get(); !perms.Done(); perm = perms.Next() {
		dist := 0
		cur := r.p[perm[0]]
		todo := make([]string, len(perm)-1)
		for i := 1; i < len(perm); i++ {
			todo[i-1] = r.p[perm[i]]
		}
		for len(todo) > 0 {
			next := todo[0]
			todo = todo[1:]
			dist += r.r[cur][next]
			cur = next
		}
		if dist < min {
			min = dist
		}
		if dist > max {
			max = dist
		}
	}
	r.min, r.max = min, max
}

func (r *Routes) Part1() int {
	return r.min
}

func (r *Routes) Part2() int {
	return r.max
}

func main() {
	r := NewRoutes(InputLines(input))
	p1 := r.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := r.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
