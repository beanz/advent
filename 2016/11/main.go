package main

import (
	"container/heap"
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Floor int

const (
	FIRST Floor = iota
	SECOND
	THIRD
	FOURTH
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
	ELEVATOR Element = iota
	THULIUM
	PLUTONIUM
	STRONTIUM
	PROMETHIUM
	RUTHENIUM
	LITHIUM
	HYDROGEN
	ELERIUM
	DILITHIUM
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

func NewGame(in []byte) *Game {
	items := make([]*Item, 0, 20)
	for i := 0; i < len(in); i++ {
		var floor Floor
		switch in[i+4] {
		case 'f':
			if in[i+5] == 'i' {
				floor = FIRST
			} else {
				floor = FOURTH
			}
		case 's':
			floor = SECOND
		case 't':
			floor = THIRD
		default:
			panic(fmt.Sprintf("invalid floor: %s", []byte{in[i+4], in[i+5]}))
		}
		i += 24
		for ; i < len(in); i++ {
			if in[i] == ' ' {
				var el Element
				switch in[i+1] {
				case 't':
					if in[i+2] == 'h' {
						el = THULIUM
						i += 7
					}
				case 'p':
					if in[i+2] == 'l' {
						el = PLUTONIUM
						i += 9
					} else if in[i+2] == 'r' {
						el = PROMETHIUM
						i += 10
					}
				case 's':
					el = STRONTIUM
					i += 9
				case 'r':
					if in[i+2] == 'u' {
						el = RUTHENIUM
						i += 9
					}
				case 'l':
					el = LITHIUM
					i += 7
				case 'e':
					el = ELERIUM
					i += 7
				case 'd':
					el = DILITHIUM
					i += 9
				case 'h':
					el = HYDROGEN
					i += 8
				}
				i++
				if el == ELEVATOR {
					continue
				}
				var k Kind
				if in[i] == '-' {
					k = CHIP
					//fmt.Printf("found %s chip\n", el)
				} else if in[i+1] == 'g' {
					k = GENERATOR
					//fmt.Printf("found %s generator\n", el)
				} else {
					panic("parsing failed")
				}
				items = append(items, &Item{el, k, floor})
			} else if in[i] == '.' {
				i++
				break
			}
		}
	}
	return &Game{items, FIRST, false}
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

type SearchQueue []Search
type PQ []*Search

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].moves < pq[j].moves
}
func (pq PQ) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
}
func (pq *PQ) Push(x interface{}) {
	item := x.(*Search)
	*pq = append(*pq, item)
}
func (pq *PQ) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	*pq = old[0 : n-1]
	return item
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
			if item.kind == CHIP {
				r = append(r, rune(byte(item.floor)+byte('0')))
			}
		} else {
			s = append(s, rune(byte(item.floor)+byte('0')), ',')
		}
	}
	s[len(s)-1] = '!'
	sort.Sort(RuneSlice(r))
	s = append(s, r...)
	return string(s)
}

func (g *Game) Part1() int {
	pq := make(PQ, 1, 1000)
	pq[0] = &Search{g.Copy(), 0}
	visited := make(map[string]bool, 6050000)
	heap.Init(&pq)
	for pq.Len() > 0 {
		//fmt.Fprintf(os.Stderr, "%d\r", len(todo))
		cur := heap.Pop(&pq).(*Search)
		key := cur.game.VisitKey()
		if visited[key] {
			continue
		}
		visited[key] = true
		if cur.game.Finished() {
			//fmt.Printf("Finished in %d moves\n", cur.moves)
			return cur.moves
		}
		floorItems := cur.game.FloorItems(cur.game.lift)
		for _, nf := range NextFloors(cur.game.lift) {
			for i := 0; i < len(floorItems); i++ {
				moved := false
				for j := i + 1; j < len(floorItems); j++ {
					ng := cur.game.Copy()
					ng.lift = nf
					ng.items[floorItems[i]].floor = ng.lift
					ng.items[floorItems[j]].floor = ng.lift
					if ng.Safe() {
						heap.Push(&pq, &Search{ng, cur.moves + 1})
					}
				}
				if moved {
					continue
				}
				ng := cur.game.Copy()
				ng.lift = nf
				ng.items[floorItems[i]].floor = ng.lift
				if ng.Safe() {
					heap.Push(&pq, &Search{ng, cur.moves + 1})
				}
			}
		}
	}
	return 0
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
	game := NewGame(InputBytes(input))
	res := game.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", res)
	}
	game = NewGame(InputBytes(input))
	res = game.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", res)
	}
}

var benchmark = false
