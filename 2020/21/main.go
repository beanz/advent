package main

import (
	"fmt"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Allergen string
type Ingredient string

type LineNum int
type Lines map[LineNum]bool
type Allergens map[Allergen]Lines
type Ingredients map[Ingredient]Lines
type Possible map[Allergen]bool

type Menu struct {
	all   Allergens
	ing   Ingredients
	poss  map[Ingredient]Possible
	debug bool
}

func NewMenu(lines []string) *Menu {
	m := Menu{
		make(Allergens),
		make(Ingredients),
		make(map[Ingredient]Possible),
		false}

	for i, l := range lines {
		ls := strings.Split(l, " (contains ")
		ing := strings.Split(ls[0], " ")
		all := strings.Split(ls[1][:len(ls[1])-1], ", ")
		for _, a := range all {
			if _, ok := m.all[Allergen(a)]; !ok {
				m.all[Allergen(a)] = make(Lines)
			}
			m.all[Allergen(a)][LineNum(i)] = true
		}
		for _, in := range ing {
			if _, ok := m.ing[Ingredient(in)]; !ok {
				m.ing[Ingredient(in)] = make(Lines)
			}
			m.ing[Ingredient(in)][LineNum(i)] = true
		}
	}
	for ing := range m.ing {
		for all, recipe := range m.all {
			maybeThisAllergen := true
			for line := range recipe {
				if !m.ing[ing][line] {
					maybeThisAllergen = false
				}
			}
			if maybeThisAllergen {
				if DEBUG() {
					fmt.Printf("%s could be %s\n", ing, all)
				}
				if _, ok := m.poss[ing]; !ok {
					m.poss[ing] = make(Possible)
				}
				m.poss[ing][all] = true
			}
		}
	}
	return &m
}

func (m *Menu) Part1() int {
	c := 0
	for ing, lines := range m.ing {
		if _, ok := m.poss[ing]; !ok {
			c += len(lines)
		}
	}
	return c
}

type Result struct {
	ing Ingredient
	all Allergen
}
type ResultList []Result

func (r ResultList) Len() int {
	return len(r)
}
func (r ResultList) Less(i, j int) bool {
	return r[i].all < r[j].all
}
func (r ResultList) Swap(i, j int) {
	r[i], r[j] = r[j], r[i]
}

func (m *Menu) Part2() string {
	resList := ResultList{}
	for len(m.poss) > 0 {
		for ing, allergens := range m.poss {
			if len(allergens) == 1 {
				var all Allergen
				for a := range allergens {
					all = a
					break
				}
				resList = append(resList, Result{all: all, ing: ing})
				delete(m.poss, ing)
				for ing := range m.poss {
					delete(m.poss[ing], all)
				}
			}
		}
	}
	sort.Sort(resList)
	r := []string{}
	for _, p := range resList {
		r = append(r, string(p.ing))
	}
	return strings.Join(r, ",")
}

func main() {
	lines := ReadInputLines()
	fmt.Printf("Part 1: %d\n", NewMenu(lines).Part1())
	fmt.Printf("Part 2: %s\n", NewMenu(lines).Part2())
}
