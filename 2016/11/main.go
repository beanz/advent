package main

import (
	"container/heap"
	_ "embed"
	"fmt"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Floor int

const (
	FIRST  Floor = 0
	SECOND       = 1
	THIRD        = 2
	FOURTH       = 3
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

func NextFloors(f Floor) []Floor {
	floors := []Floor{}
	if f > FIRST {
		floors = append(floors, f-1)
	}
	if f < FOURTH {
		floors = append(floors, f+1)
	}
	return floors
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
	case ELEVATOR:
		return "EV"
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
	}
	return "G"
}

type FloorState uint64

func (fs FloorState) Add(el Element, kind Kind, fl Floor) FloorState {
	sh := 4*int(el) + 2*int(kind)
	mask := FloorState(3 << sh)
	fs |= mask
	fs ^= mask
	fs |= FloorState(fl << sh)
	return fs
}

func (fs FloorState) At(el Element, kind Kind, fl Floor) bool {
	f := fs >> (4*int(el) + 2*int(kind))
	return Floor(f&0x3) == fl
}

func (fs FloorState) ItemFloor(el Element, kind Kind) Floor {
	sh := 4*int(el) + 2*int(kind)
	mask := FloorState(3 << sh)
	return Floor((fs & mask) >> sh)
}

type Facility struct {
	state FloorState
	end   FloorState
	names []Element
}

func NewFacility(in []byte) *Facility {
	var state FloorState
	names := make([]Element, 0, 10)
	state = state.Add(ELEVATOR, CHIP, FIRST)
	var floor Floor
	for i := 0; i < len(in); i++ {
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
				if !InList(el, names) {
					names = append(names, el)
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
				state = state.Add(el, k, floor)
			} else if in[i] == '.' {
				i++
				break
			}
		}
	}
	f := &Facility{state, 0, names}
	f.UpdateStates()
	return f
}

func (f *Facility) UpdateStates() {
	var end FloorState
	end = end.Add(ELEVATOR, CHIP, FOURTH)
	for _, el := range f.names {
		end = end.Add(el, CHIP, FOURTH)
		end = end.Add(el, GENERATOR, FOURTH)
	}
	f.end = end
}

func InList(n Element, h []Element) bool {
	for _, e := range h {
		if e == n {
			return true
		}
	}
	return false
}

func (f *Facility) StateString(state FloorState) string {
	var sb strings.Builder
	for _, fl := range []Floor{FOURTH, THIRD, SECOND, FIRST} {
		sb.WriteString(fl.String())
		sb.WriteByte(' ')
		if state.At(ELEVATOR, CHIP, fl) {
			sb.WriteByte('E')
		} else {
			sb.WriteByte('.')
		}
		sb.WriteByte(' ')
		for _, el := range f.names {
			if state.At(el, GENERATOR, fl) {
				sb.WriteString(el.String())
				sb.WriteByte('G')
			} else {
				sb.WriteString(".  ")
			}
			sb.WriteByte(' ')
			if state.At(el, CHIP, fl) {
				sb.WriteString(el.String())
				sb.WriteByte('M')
			} else {
				sb.WriteString(".  ")
			}
			sb.WriteByte(' ')
		}
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (f *Facility) String() string {
	return f.StateString(f.state)
}

func (f *Facility) Safe(state FloorState) bool {
	for _, fl := range []Floor{FOURTH, THIRD, SECOND, FIRST} {
		if !f.SafeFloor(state, fl) {
			return false
		}
	}
	return true
}

func (f *Facility) SafeFloor(state FloorState, fl Floor) bool {
	gc := 0
	mc := 0
	for _, el := range f.names {
		if state.At(el, GENERATOR, fl) {
			gc++
		} else if state.At(el, CHIP, fl) {
			// no generator!
			mc++
		}
	}
	if mc > 0 && gc > 0 {
		return false
	}
	return true
}

type Search struct {
	state FloorState
	moves uint
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

type Item struct {
	el Element
	k  Kind
}

type ByteSlice []byte

func (p ByteSlice) Len() int           { return len(p) }
func (p ByteSlice) Less(i, j int) bool { return p[i] < p[j] }
func (p ByteSlice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

func (f *Facility) VisitKey(fs FloorState) string {
	s := make(ByteSlice, 0, len(f.names)*2)
	s = append(s, byte(byte(fs.ItemFloor(ELEVATOR, CHIP))+byte('0')), '!')
	genFloor := map[Element]Floor{}
	chipFloor := map[Element]Floor{}
	for _, fl := range []Floor{FOURTH, THIRD, SECOND, FIRST} {
		for _, el := range f.names {
			if fs.At(el, CHIP, fl) {
				chipFloor[el] = fl
			}
			if fs.At(el, GENERATOR, fl) {
				genFloor[el] = fl
			}
		}
	}
	r := make(ByteSlice, 0, len(f.names))
	for _, el := range f.names {
		if genFloor[el] == chipFloor[el] {
			r = append(r, byte(byte(genFloor[el])+byte('0')))
		} else {
			s = append(s, byte(byte(genFloor[el])+byte('0')), ',')
			s = append(s, byte(byte(chipFloor[el])+byte('0')), ',')
		}
	}
	s[len(s)-1] = '!'
	sort.Sort(ByteSlice(r))
	s = append(s, r...)
	return string(s)
}

func (f *Facility) Part1() uint {
	visited := make(map[string]bool, 6050000)
	pq := make(PQ, 1, 1000)
	pq[0] = &Search{f.state, 0}
	heap.Init(&pq)
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*Search)
		//fmt.Printf("%d\r", pq.Len())
		vk := f.VisitKey(cur.state)
		if visited[vk] {
			continue
		}
		visited[vk] = true
		//fmt.Printf("checking state: %s\n%s\n", vk, f.StateString(cur.state))
		if cur.state == f.end {
			return cur.moves
		}
		liftFloor := cur.state.ItemFloor(ELEVATOR, CHIP)
		floorItems := make([]Item, 0, 20)
		for _, el := range f.names {
			if cur.state.At(el, CHIP, liftFloor) {
				floorItems = append(floorItems, Item{el, CHIP})
			}
			if cur.state.At(el, GENERATOR, liftFloor) {
				floorItems = append(floorItems, Item{el, GENERATOR})
			}
		}
		for _, nf := range NextFloors(liftFloor) {
			for i := 0; i < len(floorItems); i++ {
				moved := false
				for j := i + 1; j < len(floorItems); j++ {
					nstate := cur.state
					nstate = nstate.Add(ELEVATOR, CHIP, nf)
					nstate = nstate.Add(floorItems[i].el, floorItems[i].k, nf)
					nstate = nstate.Add(floorItems[j].el, floorItems[j].k, nf)
					if f.SafeFloor(nstate, nf) && f.SafeFloor(nstate, liftFloor) {
						moved = false
						heap.Push(&pq, &Search{nstate, cur.moves + 1})
					}
				}
				if moved {
					continue
				}
				nstate := cur.state
				nstate = nstate.Add(ELEVATOR, CHIP, nf)
				nstate = nstate.Add(floorItems[i].el, floorItems[i].k, nf)
				if f.SafeFloor(nstate, nf) && f.SafeFloor(nstate, liftFloor) {
					heap.Push(&pq, &Search{nstate, cur.moves + 1})
				}
			}
		}
	}
	return 0
}

func (f *Facility) Part2() uint {
	f.names = append(f.names, ELERIUM, DILITHIUM)
	f.state = f.state.Add(ELERIUM, GENERATOR, FIRST)
	f.state = f.state.Add(ELERIUM, CHIP, FIRST)
	f.state = f.state.Add(DILITHIUM, GENERATOR, FIRST)
	f.state = f.state.Add(DILITHIUM, CHIP, FIRST)

	f.UpdateStates()
	return f.Part1()
}

func main() {
	f := NewFacility(InputBytes(input))
	p1 := f.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := f.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
