package main

import (
	"fmt"
	"sort"
)

type Floor int

const (
	FIRST  Floor = 1
	SECOND       = 2
	THIRD        = 3
	FOURTH       = 4
)

func (f Floor) String() string {
	switch f {
	case FIRST:
		return "1"
	case SECOND:
		return "2"
	case THIRD:
		return "3"
	default:
		return "4"
	}
}

type Element int

const (
	THULIUM    Element = 0
	PLUTONIUM          = 1
	STRONTIUM          = 2
	PROMETHIUM         = 3
	RUTHENIUM          = 4
	LITHIUM            = 5
	HYDROGEN           = 6
	ELERIUM            = 7
	DILITHIUM          = 8
)

func (e Element) String() string {
	switch e {
	case THULIUM:
		return "TH"
	case PLUTONIUM:
		return "PL"
	case STRONTIUM:
		return "ST"
	case PROMETHIUM:
		return "PR"
	case LITHIUM:
		return "LI"
	case HYDROGEN:
		return "HY"
	case ELERIUM:
		return "EL"
	case DILITHIUM:
		return "DI"
	default:
		return "RU"
	}
}

type Kind int

const (
	CHIP      Kind = 0
	GENERATOR      = 1
)

func (k Kind) String() string {
	if k == CHIP {
		return "M"
	} else {
		return "G"
	}
}

type Item struct {
	element Element
	kind    Kind
	floor   Floor
}

func (item Item) String() string {
	return fmt.Sprintf("%s%s", item.element, item.kind)
}

type Game struct {
	items []*Item
	lift  Floor
	debug bool
}

func (g *Game) Copy() *Game {
	ni := make([]*Item, len(g.items))
	ng := &Game{ni, g.lift, g.debug}
	for i, item := range g.items {
		newItem := *item
		ng.items[i] = &newItem
	}
	return ng
}

func (g *Game) String() string {
	s := ""
	for _, floor := range []Floor{FOURTH, THIRD, SECOND, FIRST} {
		s += fmt.Sprintf("%s: ", floor)
		if g.lift == floor {
			s += "L "
		} else {
			s += "_ "
		}
		for _, item := range g.items {
			if item.floor == floor {
				s += fmt.Sprintf("%s ", item)
			} else {
				s += "___ "
			}
		}
		s += "\n"
	}
	return s
}

func readGame() *Game {
	return &Game{[]*Item{
		&Item{THULIUM, GENERATOR, FIRST},
		&Item{THULIUM, CHIP, FIRST},
		&Item{PLUTONIUM, GENERATOR, FIRST},
		&Item{STRONTIUM, GENERATOR, FIRST},
		&Item{PLUTONIUM, CHIP, SECOND},
		&Item{STRONTIUM, CHIP, SECOND},
		&Item{PROMETHIUM, GENERATOR, THIRD},
		&Item{PROMETHIUM, CHIP, THIRD},
		&Item{RUTHENIUM, GENERATOR, THIRD},
		&Item{RUTHENIUM, CHIP, THIRD},
	}, FIRST, false}
}

func (g *Game) Finished() bool {
	for _, item := range g.items {
		if item.floor != FOURTH {
			return false
		}
	}
	return true
}

func (g *Game) Safe() bool {
	genFloor := map[Element]Floor{}
	chipFloor := map[Element]Floor{}
	genCount := map[Floor]int{}
	for _, item := range g.items {
		if item.kind == CHIP {
			chipFloor[item.element] = item.floor
		} else {
			genFloor[item.element] = item.floor
			genCount[item.floor]++
		}
	}
	for k := range chipFloor {
		if chipFloor[k] != genFloor[k] && genCount[chipFloor[k]] > 0 {
			return false
		}
	}
	return true
}

func (g *Game) MoveItems(items []int) {
	for _, movedItem := range items {
		if g.debug {
			fmt.Printf("moving item %s from %s to %s\n",
				g.items[movedItem], g.items[movedItem].floor, g.lift)
		}
		g.items[movedItem].floor = g.lift
	}
}

func (g *Game) FloorItems(f Floor) []int {
	items := []int{}
	for i, item := range g.items {
		if item.floor == f {
			items = append(items, i)
		}
	}
	return items
}

func ItemChoices(items []int) [][]int {
	choices := [][]int{}
	for i := 0; i < len(items); i++ {
		choices = append(choices, []int{items[i]})
		for j := i + 1; j < len(items); j++ {
			choices = append(choices, []int{items[i], items[j]})
		}
	}
	return choices
}

func NextFloors(floor Floor) []Floor {
	floors := []Floor{}
	if floor > FIRST {
		floors = append(floors, floor-1)
	}
	if floor < FOURTH {
		floors = append(floors, floor+1)
	}
	return floors
}

type Search struct {
	game  *Game
	moves int
}

func (s Search) String() string {
	return fmt.Sprintf("Moves %d\n%s\n", s.moves, s.game)
}

type RuneSlice []rune

func (p RuneSlice) Len() int           { return len(p) }
func (p RuneSlice) Less(i, j int) bool { return p[i] < p[j] }
func (p RuneSlice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

func (g *Game) VisitKey() string {
	s := make(RuneSlice, 0, len(g.items)*2)
	s = append(s, rune(byte(g.lift)+byte('0')), '!')
	genFloor := map[Element]Floor{}
	chipFloor := map[Element]Floor{}
	for _, item := range g.items {
		if item.kind == CHIP {
			chipFloor[item.element] = item.floor
		} else {
			genFloor[item.element] = item.floor
		}
	}
	r := make(RuneSlice, 0, len(g.items))
	for _, item := range g.items {
		if genFloor[item.element] == chipFloor[item.element] {
			r = append(r, rune(byte(item.floor)+byte('0')))
		} else {
			s = append(s, rune(byte(item.floor)+byte('0')), ',')
		}
	}
	sort.Sort(RuneSlice(r))
	s = append(s, r...)
	return string(s)
}

func (g *Game) Part1() int {
	todo := []Search{Search{g.Copy(), 0}}
	best := 1000000
	visited := map[string]bool{}
	for len(todo) > 0 {
		//fmt.Fprintf(os.Stderr, "%d\r", len(todo))
		cur := todo[0]
		key := cur.game.VisitKey()
		todo = todo[1:]
		if visited[key] {
			continue
		}
		visited[key] = true
		if cur.game.Finished() {
			fmt.Printf("Finished in %d moves\n", cur.moves)
			if cur.moves < best {
				best = cur.moves
				continue
			}
		}
		if cur.moves > best {
			continue
		}
		floorItems := cur.game.FloorItems(cur.game.lift)
		for _, nf := range NextFloors(cur.game.lift) {
			for _, items := range ItemChoices(floorItems) {
				ng := cur.game.Copy()
				ng.lift = nf
				ng.MoveItems(items)
				if ng.Safe() {
					todo = append(todo, Search{ng, cur.moves + 1})
				}
			}
		}
	}
	return best
}

func (g *Game) Part2() int {
	g.items = append(g.items,
		&Item{ELERIUM, GENERATOR, FIRST},
		&Item{ELERIUM, CHIP, FIRST},
		&Item{DILITHIUM, GENERATOR, FIRST},
		&Item{DILITHIUM, CHIP, FIRST},
	)
	return g.Part1()
}

func main() {
	game := readGame()
	fmt.Printf("%s\n", game)

	res := game.Part1()
	fmt.Printf("Part 1: %d\n", res)
	//fmt.Printf("%s\n", game)

	game = readGame()
	fmt.Printf("%s\n", game)
	res = game.Part2()
	fmt.Printf("Part 2: %d\n", res)
}
