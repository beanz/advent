package main

import (
	"container/heap"
	_ "embed"
	"fmt"
	"math"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Vault struct {
	m        *ByteMap
	pos      int
	keys     int
	quadKeys map[byte]map[byte]bool
	debug    bool
}

func NewVault(in []byte) *Vault {
	m := NewByteMap(in)
	var pos int
	keys := 0
	m.Visit(func(i int, ch byte) (byte, bool) {
		if ch == '@' {
			pos = i
			return '.', true
		}
		if 'a' <= ch && ch <= 'z' {
			keys++
		}
		return ch, false
	})
	return &Vault{m, pos, keys, make(map[byte]map[byte]bool, 4), false}
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

func (v *Vault) isKeyInQuad(key byte, quad byte) bool {
	if quad == '*' {
		return true
	}
	_, ok := v.quadKeys[quad][key]
	return ok
}

func (v *Vault) findKeys(pos int, quad byte) {
	v.quadKeys[quad] = make(map[byte]bool)
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
			v.quadKeys[quad][ch] = true
		}
		for _, np := range v.m.Neighbours(cur) {
			search = append(search, np)
		}
	}
}

func SortString(w string) string {
	s := strings.Split(w, "")
	sort.Strings(s)
	return strings.Join(s, "")
}

type SearchRecord struct {
	pos        int
	steps      int
	remaining  int
	keys       map[byte]bool
	path       string
	sortedPath string
}

type Search []SearchRecord

type PQ []*SearchRecord

func (pq PQ) Len() int { return len(pq) }

func (pq PQ) Less(i, j int) bool {
	return pq[i].remaining < pq[j].remaining
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
	pos  int
	path string
}

func (v *Vault) find(pos int, quad byte) int {
	var expectedKeys int
	if quad == '*' {
		expectedKeys = v.keys
	} else {
		expectedKeys = len(v.quadKeys[quad])
	}
	if v.debug {
		fmt.Printf("Searching for %d keys in quad %s\n",
			expectedKeys, string(quad))
	}
	visited := make(map[VisitKey]int)
	pq := make(PQ, 1)
	pq[0] = &SearchRecord{pos, 0,
		expectedKeys, make(map[byte]bool, expectedKeys),
		"", ""}
	min := math.MaxInt32
	heap.Init(&pq)
	for pq.Len() > 0 {
		if v.debug {
			fmt.Printf("pq len: %d\n", pq.Len())
		}
		cur := heap.Pop(&pq).(*SearchRecord)
		ch := v.m.Get(cur.pos)
		if v.debug {
			fmt.Printf("checking %s %s '%s'\n",
				v.m.IndexToString(cur.pos), cur.path, string(ch))
		}
		if ch == '#' {
			continue
		}
		if cur.steps > min {
			if v.debug {
				fmt.Printf("  too many steps: %d > %d\n", cur.steps, min)
			}
			continue
		}
		if 'A' <= ch && ch <= 'Z' {
			lch := ch + 32
			if _, ok := cur.keys[lch]; !ok &&
				v.isKeyInQuad(lch, quad) {
				if v.debug {
					fmt.Printf("  blocked by door %s\n", string(ch))
				}
				continue
			}
		} else if 'a' <= ch && ch <= 'z' {
			if _, ok := cur.keys[ch]; !ok {
				if v.debug {
					fmt.Printf("  found key %s (%ds)\n", string(ch), cur.steps)
				}
				cur.keys[ch] = true
				cur.remaining--
				cur.path += string(ch)
				cur.sortedPath = SortString(cur.path)
				if cur.remaining == 0 {
					if v.debug {
						fmt.Printf("Found all keys via %s in %d\n",
							cur.path, cur.steps)
					}
					if min > cur.steps {
						min = cur.steps
					}
					continue
				}
			}
		}
		vkey := VisitKey{cur.pos, cur.sortedPath}
		if vs, ok := visited[vkey]; ok && vs <= cur.steps {
			if v.debug {
				fmt.Printf("  de ja vu (%v)\n", vkey)
			}
			continue
		}
		visited[vkey] = cur.steps
		for _, np := range v.m.Neighbours(cur.pos) {
			if v.m.Get(np) == '#' {
				continue
			}
			newKeys := make(map[byte]bool, len(cur.keys))
			for k, v := range cur.keys {
				newKeys[k] = v
			}
			new := &SearchRecord{np, cur.steps + 1, cur.remaining, newKeys,
				cur.path, cur.sortedPath}
			heap.Push(&pq, new)
		}
	}
	return min
}

func (v *Vault) part1() int {
	return v.find(v.pos, '*')
}

type QuadRecord struct {
	startOffset Point
	name        byte
}

func (v *Vault) part2() int {
	for _, np := range v.m.Neighbours(v.pos) {
		v.m.Set(np, '#')
	}
	if v.debug {
		fmt.Printf("%s\n", v)
	}
	quads := []QuadRecord{
		QuadRecord{Point{-1, -1}, 'A'},
		QuadRecord{Point{1, -1}, 'B'},
		QuadRecord{Point{-1, 1}, 'C'},
		QuadRecord{Point{1, 1}, 'D'},
	}
	sum := 0
	for _, rec := range quads {
		x, y := v.m.IndexToXY(v.pos)
		start := v.m.XYToIndex(x+rec.startOffset.X, y+rec.startOffset.Y)
		quad := rec.name
		v.findKeys(start, quad)
		if v.debug {
			fmt.Printf("Quad %s / %s has %d keys\n",
				string(quad), v.m.IndexToString(start), len(v.quadKeys[quad]))
		}
		sum += v.find(start, quad)
	}
	return sum
}

func main() {
	inp := InputBytes(input)
	vault := NewVault(inp)
	if vault.debug {
		fmt.Printf("%s\n", vault)
	}
	vault.Optimaze()
	if vault.debug {
		fmt.Printf("%s\n", vault)
	}
	p1 := vault.part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := vault.part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
