package main

import (
	"fmt"
	"math"
	"strings"

	. "github.com/beanz/advent2015/lib"
)

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
	perms := Permutations(0, len(r.p)-1)
	min := math.MaxInt32
	max := math.MinInt32
	for _, perm := range perms {
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
	r := NewRoutes(ReadInputLines())
	fmt.Printf("Part 1: %d\n", r.Part1())
	fmt.Printf("Part 2: %d\n", r.Part2())
}

func Permutations(min, max int) [][]int {
	orig := []int{}
	for i := min; i <= max; i++ {
		orig = append(orig, i)
	}
	var helper func([]int, int)
	res := [][]int{}

	helper = func(orig []int, n int) {
		if n == 1 {
			tmp := make([]int, len(orig))
			copy(tmp, orig)
			res = append(res, tmp)
		} else {
			for i := 0; i < n; i++ {
				helper(orig, n-1)
				if n%2 == 1 {
					tmp := orig[i]
					orig[i] = orig[n-1]
					orig[n-1] = tmp
				} else {
					tmp := orig[0]
					orig[0] = orig[n-1]
					orig[n-1] = tmp
				}
			}
		}
	}
	helper(orig, len(orig))
	return res
}
