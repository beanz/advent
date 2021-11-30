package main

import (
	"container/heap"
	"fmt"
	"log"
	"math"
	"os"
	"sort"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Rogue struct {
	m        map[Point]rune
	bb       *BoundingBox
	pos      Point
	keys     int
	quadKeys map[rune]map[rune]bool
	debug    bool
}

func NewRogue(lines []string) *Rogue {
	bb := NewBoundingBox()
	bb.Add(Point{0, 0})
	bb.Add(Point{len(lines[0]) - 1, len(lines) - 1})
	m := make(map[Point]rune)
	pos := Point{-1, -1}
	keys := 0
	for y, line := range lines {
		for x, ch := range line {
			if ch == '@' {
				pos = Point{x, y}
				ch = '.'
			} else if 'a' <= ch && ch <= 'z' {
				keys++
			}
			m[Point{x, y}] = ch
		}
	}
	return &Rogue{m, bb, pos, keys, make(map[rune]map[rune]bool), false}
}

func (r *Rogue) String() string {
	str := ""
	for y := r.bb.Min.Y; y <= r.bb.Max.Y; y++ {
		for x := r.bb.Min.X; x <= r.bb.Max.X; x++ {
			if r.pos.X == x && r.pos.Y == y {
				str += "@"
			} else {
				str += string(r.m[Point{x, y}])
			}
		}
		str += "\n"
	}
	return str
}

func (r *Rogue) Optimaze() {
	for {
		changes := 0
		for y := r.bb.Min.Y; y <= r.bb.Max.Y; y++ {
			for x := r.bb.Min.X; x <= r.bb.Max.X; x++ {
				p := Point{x, y}
				if r.m[p] != '.' {
					continue
				}
				if r.pos.X == x && r.pos.Y == y {
					continue
				}
				nw := 0
				for _, np := range p.Neighbours() {
					if r.m[np] == '#' {
						nw++
					}
				}
				if nw > 2 {
					r.m[p] = '#'
					changes++
				}
			}
		}
		if changes == 0 {
			break
		}
	}
}

func (r *Rogue) isKeyInQuad(key rune, quad rune) bool {
	if quad == '*' {
		return true
	}
	_, ok := r.quadKeys[quad][key]
	return ok
}

func (r *Rogue) findKeys(pos Point, quad rune) {
	r.quadKeys[quad] = make(map[rune]bool)
	visited := make(map[Point]bool)
	search := []Point{pos}
	for len(search) > 0 {
		cur := search[0]
		search = search[1:]
		ch := r.m[cur]
		if ch == '#' {
			continue
		}
		if _, ok := visited[cur]; ok {
			continue
		}
		visited[cur] = true
		if 'a' <= ch && ch <= 'z' {
			r.quadKeys[quad][ch] = true
		}
		for _, np := range cur.Neighbours() {
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
	pos        Point
	steps      int
	remaining  int
	keys       map[rune]bool
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

func (r *Rogue) find(pos Point, quad rune) int {
	var expectedKeys int
	if quad == '*' {
		expectedKeys = r.keys
	} else {
		expectedKeys = len(r.quadKeys[quad])
	}
	if r.debug {
		fmt.Printf("Searching for %d keys in quad %s\n",
			expectedKeys, string(quad))
	}
	visited := make(map[string]int)
	pq := make(PQ, 1)
	pq[0] = &SearchRecord{pos, 0,
		expectedKeys, make(map[rune]bool, expectedKeys),
		"", ""}
	min := math.MaxInt32
	heap.Init(&pq)
	for pq.Len() > 0 {
		if r.debug {
			fmt.Printf("pq len: %d\n", pq.Len())
		}
		cur := heap.Pop(&pq).(*SearchRecord)
		ch := r.m[cur.pos]
		if r.debug {
			fmt.Printf("checking %s %s '%s'\n", cur.pos, cur.path, string(ch))
		}
		if ch == '#' {
			continue
		}
		if cur.steps > min {
			if r.debug {
				fmt.Printf("  too many steps: %d > %d\n", cur.steps, min)
			}
			continue
		}
		if 'A' <= ch && ch <= 'Z' {
			lch := ch + 32
			if _, ok := cur.keys[lch]; !ok &&
				r.isKeyInQuad(lch, quad) {
				if r.debug {
					fmt.Printf("  blocked by door %s\n", string(ch))
				}
				continue
			}
		} else if 'a' <= ch && ch <= 'z' {
			if _, ok := cur.keys[ch]; !ok {
				if r.debug {
					fmt.Printf("  found key %s (%ds)\n", string(ch), cur.steps)
				}
				cur.keys[ch] = true
				cur.remaining--
				cur.path += string(ch)
				cur.sortedPath = SortString(cur.path)
				if cur.remaining == 0 {
					if r.debug {
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
		vkey := fmt.Sprintf("%d!%d!%s",
			cur.pos.X, cur.pos.Y, cur.sortedPath)
		if v, ok := visited[vkey]; ok && v <= cur.steps {
			if r.debug {
				fmt.Printf("  de ja vu (%s)\n", vkey)
			}
			continue
		}
		visited[vkey] = cur.steps
		for _, np := range cur.pos.Neighbours() {
			if r.m[np] == '#' {
				continue
			}
			newKeys := make(map[rune]bool, len(cur.keys))
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

func (r *Rogue) part1() int {
	return r.find(r.pos, '*')
}

type QuadRecord struct {
	startOffset Point
	name        rune
}

func (r *Rogue) part2() int {
	for _, np := range r.pos.Neighbours() {
		r.m[np] = '#'
	}
	if r.debug {
		fmt.Printf("%s\n", r)
	}
	quads := []QuadRecord{
		QuadRecord{Point{-1, -1}, 'A'},
		QuadRecord{Point{1, -1}, 'B'},
		QuadRecord{Point{-1, 1}, 'C'},
		QuadRecord{Point{1, 1}, 'D'},
	}
	sum := 0
	for _, rec := range quads {
		start := Point{r.pos.X + rec.startOffset.X,
			r.pos.Y + rec.startOffset.Y}
		quad := rec.name
		r.findKeys(start, quad)
		if r.debug {
			fmt.Printf("Quad %s / %s has %d keys\n",
				string(quad), start, len(r.quadKeys[quad]))
		}
		sum += r.find(start, quad)
	}
	return sum
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	rogue := NewRogue(lines)
	if rogue.debug {
		fmt.Printf("%s\n", rogue)
	}
	rogue.Optimaze()
	if rogue.debug {
		fmt.Printf("%s\n", rogue)
	}
	fmt.Printf("Part 1: %d\n", rogue.part1())
	fmt.Printf("Part 2: %d\n", rogue.part2())
}
