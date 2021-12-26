package main

import (
	"container/heap"
	_ "embed"
	"fmt"
	"math/bits"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Vault struct {
	m        *ByteMap
	pos      int
	keys     int
	keySet   AlphaNumSet
	quadKeys []AlphaNumSet
	debug    bool
}

func NewVault(in []byte) *Vault {
	m := NewByteMap(in)
	var pos int
	keys := 0
	cs := AlphaNumSet(0)
	m.Visit(func(i int, ch byte) (byte, bool) {
		if ch == '@' {
			pos = i
			return '.', true
		}
		if 'a' <= ch && ch <= 'z' {
			keys++
			cs = cs.Add(ch)
		}
		return ch, false
	})
	return &Vault{m, pos, keys, cs, make([]AlphaNumSet, 4), DEBUG()}
}

func (v *Vault) String() string {
	var sb strings.Builder
	for y := 0; y < v.m.Height(); y++ {
		for x := 0; x < v.m.Width(); x++ {
			if v.pos == v.m.XYToIndex(x, y) {
				sb.WriteByte('@')
			} else {
				sb.WriteByte(v.m.GetXY(x, y))
			}
		}
		sb.WriteByte('\n')
	}
	return sb.String()
}

func (v *Vault) Optimaze() {
	for {
		changes := 0
		v.m.Visit(func(i int, ch byte) (byte, bool) {
			if ch != '.' {
				return ch, false
			}
			if v.pos == i {
				return ch, false
			}
			nw := 0
			for _, nch := range v.m.NeighbourValues(i) {
				if nch == '#' {
					nw++
				}
			}
			if nw > 2 {
				changes++
				return '#', true
			}
			return ch, false
		})
		if changes == 0 {
			break
		}
	}
}

func (v *Vault) isKeyInQuad(key byte, quad int) bool {
	if quad == -1 {
		return true
	}
	bit := AlphaNumBit(key)
	return (v.quadKeys[quad] & bit) != 0
}

func (v *Vault) findKeys(pos int, quad int) {
	v.quadKeys[quad] = NewAlphaNumSet()
	visited := make([]bool, 82*82) // TOFIX v.m.maxindex?
	search := []int{pos}
	for len(search) > 0 {
		cur := search[0]
		search = search[1:]
		ch := v.m.Get(cur)
		if ch == '#' {
			continue
		}
		if visited[cur] {
			continue
		}
		visited[cur] = true
		if 'a' <= ch && ch <= 'z' {
			v.quadKeys[quad] = v.quadKeys[quad].Add(ch)
		}
		for _, np := range v.m.Neighbours(cur) {
			search = append(search, np)
		}
	}
}

type SearchRecord struct {
	pos       int
	steps     int
	remaining int
	keys      AlphaNumSet
}

type Search []SearchRecord

type PQ []*SearchRecord

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].steps < pq[j].steps
}

func (pq PQ) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
}

func (pq *PQ) Push(x interface{}) {
	item := x.(*SearchRecord)
	*pq = append(*pq, item)
}

func (pq *PQ) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	*pq = old[0 : n-1]
	return item
}

type VisitKey struct {
	pos       int
	foundKeys uint64
}

func (v *Vault) find(pos int, quad int) int {
	var expectedKeys int
	if quad == -1 {
		expectedKeys = v.keys
	} else {
		expectedKeys = v.quadKeys[quad].Size()
	}
	if v.debug {
		fmt.Printf("Searching for %d keys in quad %d\n", expectedKeys, quad)
	}
	visited := make(map[VisitKey]int, 1280000)
	pq := make(PQ, 1)
	pq[0] = &SearchRecord{pos, 0, expectedKeys, NewAlphaNumSet()}
	heap.Init(&pq)
	for pq.Len() > 0 {
		cur := heap.Pop(&pq).(*SearchRecord)
		ch := v.m.Get(cur.pos)
		//fmt.Printf("checking %s '%s'\n",v.m.IndexToString(cur.pos), string(ch))
		if 'A' <= ch && ch <= 'Z' {
			lch := ch + 32
			if !cur.keys.Contains(lch) && v.isKeyInQuad(lch, quad) {
				//fmt.Printf("  blocked by door %s\n", string(ch))
				continue
			}
		} else if 'a' <= ch && ch <= 'z' {
			if !cur.keys.Contains(ch) {
				//fmt.Printf("  found key %s (%ds)\n", string(ch), cur.steps)
				cur.keys = cur.keys.Add(ch)
				cur.remaining--
				if cur.remaining == 0 {
					//fmt.Printf("Found all keys in %d\n", cur.steps)
					return cur.steps
				}
			}
		}
		vkey := VisitKey{cur.pos, uint64(cur.keys)}
		if _, ok := visited[vkey]; ok {
			continue
		}
		visited[vkey] = cur.steps
		for _, np := range v.m.Neighbours(cur.pos) {
			if v.m.Get(np) == '#' {
				continue
			}
			new := &SearchRecord{np, cur.steps + 1, cur.remaining, cur.keys}
			heap.Push(&pq, new)
		}
	}
	return -1
}

func (v *Vault) Part1() int {
	return v.find(v.pos, -1)
}

type QuadRecord struct {
	startOffset Point
	indexname   byte
}

func (v *Vault) Part2() int {
	for _, np := range v.m.Neighbours(v.pos) {
		v.m.Set(np, '#')
	}
	if v.debug {
		fmt.Printf("%s\n", v)
	}
	quads := []Point{{-1, -1}, {1, -1}, {-1, 1}, {1, 1}}
	sum := 0
	for i, start := range quads {
		x, y := v.m.IndexToXY(v.pos)
		start := v.m.XYToIndex(x+start.X, y+start.Y)
		v.findKeys(start, i)
		if v.debug {
			fmt.Printf("Quad %d / %s has %d keys\n",
				i, v.m.IndexToString(start), v.quadKeys[i].Size())
		}
		sum += v.find(start, i)
	}
	return sum
}

func main() {
	vault := NewVault(InputBytes(input))
	if vault.debug {
		fmt.Printf("%s\n", vault)
	}
	vault.Optimaze()
	if vault.debug {
		fmt.Printf("%s\n", vault)
	}
	p1 := vault.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := vault.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false

type AlphaNumSet uint64

func NewAlphaNumSet() AlphaNumSet {
	return AlphaNumSet(0)
}

func (s AlphaNumSet) Add(ch byte) AlphaNumSet {
	s |= AlphaNumBit(ch)
	return s
}

func (s AlphaNumSet) Size() int {
	return bits.OnesCount64(uint64(s))
}

func (s AlphaNumSet) Contains(ch byte) bool {
	return (s & AlphaNumBit(ch)) != 0
}

func (s AlphaNumSet) String() string {
	var sb strings.Builder
	var bit AlphaNumSet = 1
	for ch := byte('0'); ch <= '9'; ch, bit = ch+1, bit<<1 {
		if (s & bit) != 0 {
			sb.WriteByte(ch)
		}
	}
	for ch := byte('A'); ch <= 'Z'; ch, bit = ch+1, bit<<1 {
		if (s & bit) != 0 {
			sb.WriteByte(ch)
		}
	}
	for ch := byte('a'); ch <= 'z'; ch, bit = ch+1, bit<<1 {
		if (s & bit) != 0 {
			sb.WriteByte(ch)
		}
	}
	return sb.String()
}

func AlphaNumBit(ch byte) AlphaNumSet {
	switch {
	case ch >= 97:
		ch -= (6 + 7 + 48)
	case ch >= 65:
		ch -= (7 + 48)
	case ch >= 48:
		ch -= 48
	}
	return AlphaNumSet(1 << ch)
}
