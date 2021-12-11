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

type Ing struct {
	cap, dur, fla, tex, cal int
}

type Recipe struct {
	ing    map[string]Ing
	i      []string
	p1, p2 int
}

func NewRecipe(in []string) *Recipe {
	r := &Recipe{ing: make(map[string]Ing, len(in)), i: []string{},
		p1: 0, p2: 0}
	for _, l := range in {
		ints := Ints(l)
		name := strings.Split(l, " ")[0]
		r.ing[name] = Ing{
			cap: ints[0],
			dur: ints[1],
			fla: ints[2],
			tex: ints[3],
			cal: ints[4],
		}
		r.i = append(r.i, name)
	}
	return r
}

func (r *Recipe) Score(amounts []int) (int, int) {
	cal := 0
	cap := 0
	dur := 0
	fla := 0
	tex := 0
	for j, ing := range r.i {
		cap += amounts[j] * r.ing[ing].cap
		dur += amounts[j] * r.ing[ing].dur
		fla += amounts[j] * r.ing[ing].fla
		tex += amounts[j] * r.ing[ing].tex
		cal += amounts[j] * r.ing[ing].cal
	}
	score := MaxInt(0, cap) * MaxInt(0, dur) * MaxInt(0, fla) * MaxInt(0, tex)
	//fmt.Printf("amounts=%v => %d * %d * %d * %d = %d\n",
	// amounts, cap, dur, fla, tex, score)
	return score, cal
}

func (r *Recipe) Calc() {
	max1 := math.MinInt32
	max2 := math.MinInt32
	for _, a := range Variations(len(r.i), 100) {
		s, cal := r.Score(a)
		if s > max1 {
			max1 = s
		}
		if cal == 500 && s > max2 {
			max2 = s
		}
	}
	r.p1, r.p2 = max1, max2
}

func (r *Recipe) Part1() int {
	if r.p1 == 0 {
		r.Calc()
	}
	return r.p1
}

func (r *Recipe) Part2() int {
	if r.p2 == 0 {
		r.Calc()
	}
	return r.p2
}

func main() {
	r := NewRecipe(InputLines(input))
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
