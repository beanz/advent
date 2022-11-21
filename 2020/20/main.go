package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

var monster = []string{
	"                  # ",
	"#    ##    ##    ###",
	" #  #  #  #  #  #   ",
}

type Tile struct {
	num    uint64
	lines  []string
	orient string
}

func NewTile(s string) *Tile {
	lines := strings.Split(s, "\n")
	first, lines := lines[0], lines[1:]
	fs := strings.Split(first, " ")
	num := MustParseUint64(fs[1][0 : len(fs[1])-1])
	return &Tile{num: num, lines: lines, orient: ""}
}

func (t *Tile) Num() uint64 {
	return t.num
}

func (t *Tile) Lines() []string {
	return t.lines
}

func (t *Tile) ImageLine(i int) string {
	return t.lines[i][1 : len(t.lines[i])-1]
}

func (t *Tile) Flip() *Tile {
	rev := make([]string, len(t.lines))
	l := len(t.lines)
	for i := 0; i < l; i++ {
		rev[l-1-i] = t.lines[i]
	}
	return &Tile{num: t.num, lines: rev, orient: t.orient + "f"}
}

func (t *Tile) Rotate() *Tile {
	return &Tile{
		num:    t.num,
		lines:  RotateStrings(t.lines),
		orient: t.orient + "r",
	}
}

func (t *Tile) Top() string {
	return t.lines[0]
}

func (t *Tile) Right() string {
	s := ""
	for _, l := range t.lines {
		s += string(l[len(l)-1])
	}
	return s
}

func (t *Tile) Left() string {
	s := ""
	for _, l := range t.lines {
		s += string(l[0])
	}
	return s
}

func (t *Tile) Bottom() string {
	return t.lines[len(t.lines)-1]
}

func (t *Tile) String() string {
	return fmt.Sprintf("Tile %d:\n", t.Num()) +
		strings.Join(t.lines, "\n") + "\n"
}

type Tiles map[uint64]*Tile
type Edges map[string][]uint64

type Water struct {
	tiles Tiles
	edges Edges
	debug bool
}

func CanonicalEdge(e string) string {
	r := ReverseString(e)
	if r < e {
		return r
	}
	return e
}

func NewWater(in []string) *Water {
	tiles := make(Tiles, len(in))
	edges := make(Edges, len(in)*4)
	for _, ch := range in {
		ch = strings.TrimSuffix(ch, "\n")
		tile := NewTile(ch)
		tiles[tile.Num()] = tile
		for _, s := range []string{tile.Top(), tile.Bottom(), tile.Left(), tile.Right()} {
			s = CanonicalEdge(s)
			edges[s] = append(edges[s], tile.Num())
		}
	}
	return &Water{tiles, edges, true}
}

func (w *Water) EdgeTiles(e string) []uint64 {
	s := CanonicalEdge(e)
	return w.edges[s]
}

func (w *Water) EdgeTileCount(e string) int {
	return len(w.EdgeTiles(e))
}

func (w *Water) Part1() uint64 {
	var p uint64 = 1
	for tn, t := range w.tiles {
		c := 0
		for _, e := range []string{t.Top(), t.Left(), t.Bottom(), t.Right()} {
			if w.EdgeTileCount(e) > 1 {
				c++
			}
		}
		if c == 2 {
			p *= tn
		}
	}
	return p
}

func (w *Water) FindRightTile(t *Tile) *Tile {
	edge := t.Right()
	matching := w.EdgeTiles(edge)
	var match uint64
	for _, tn := range matching {
		if tn != t.Num() {
			match = tn
			break
		}
	}
	if match == 0 {
		return nil
	}
	tn := w.tiles[match]
	for i := 0; i < 8; i++ {
		if tn.Left() == edge {
			return tn
		}
		if i == 3 {
			tn = tn.Flip()
		} else {
			tn = tn.Rotate()
		}
	}
	panic(fmt.Sprintf("Failed to find next tile orientation\n%s\n\n%s\n",
		t, tn))
	return nil
}

func (w *Water) FindBottomTile(t *Tile) *Tile {
	edge := t.Bottom()
	matching := w.EdgeTiles(edge)
	var match uint64
	for _, tn := range matching {
		if tn != t.Num() {
			match = tn
			break
		}
	}
	if match == 0 {
		return nil
	}
	tn := w.tiles[match]
	for i := 0; i < 8; i++ {
		if tn.Top() == edge {
			return tn
		}
		if i == 3 {
			tn = tn.Flip()
		} else {
			tn = tn.Rotate()
		}
	}
	panic(fmt.Sprintf("Failed to find next tile orientation %d <-> %d\n",
		t.Num(), tn.Num()))
	return nil
}

func (w *Water) Image() []string {
	var starter uint64
	for tn, t := range w.tiles {
		c := 0
		for _, e := range []string{t.Top(), t.Left(), t.Bottom(), t.Right()} {
			if w.EdgeTileCount(e) > 1 {
				c++
			}
		}
		if c == 2 {
			starter = tn
			break
		}
	}
	if DEBUG() {
		fmt.Printf("starting with %d\n %d", starter, starter)
	}
	res := [][]*Tile{{}}
	i := 0
	t := w.tiles[starter]
	// rotating to correct orientation
	for w.EdgeTileCount(t.Right()) != 2 || w.EdgeTileCount(t.Bottom()) != 2 {
		t = t.Rotate()
	}
	pt := t
	res[i] = append(res[i], t)
	for {
		t := w.FindRightTile(pt)
		if t == nil {
			t = res[i][0]
			t = w.FindBottomTile(t)
			if t == nil {
				break
			}
			res = append(res, []*Tile{})
			i++
			if DEBUG() {
				fmt.Printf("\n")
			}
		}
		if DEBUG() {
			fmt.Printf(" %d", t.Num())
		}
		res[i] = append(res[i], t)
		pt = t
	}
	if DEBUG() {
		fmt.Printf("\n")
	}
	lines := []string{}
	for _, line := range res {
		for i := 1; i < len(line[0].Top())-1; i++ {
			lineStr := ""
			for _, t := range line {
				lineStr += t.ImageLine(i)
			}
			lines = append(lines, lineStr)
		}
	}
	return lines
}

func (w *Water) Part2() int {
	image := w.Image()
	mh := len(monster)
	mw := len(monster[0])
	ih := len(image)
	iw := len(image[0])
	if DEBUG() {
		for _, l := range image {
			fmt.Printf("%s\n", l)
		}
		fmt.Printf("image %d x %d\n", iw, ih)
		fmt.Printf("monster %d x %d\n", mw, mh)
	}
	monsterSize := 0
	for mr := 0; mr < mh; mr++ {
		for mc := 0; mc < mw; mc++ {
			if monster[mr][mc] != '#' {
				continue
			}
			monsterSize++
		}
	}

	mchars := 0
	for i := 0; i < 8; i++ {
		for r := 0; r < ih-mh; r++ {
			for c := 0; c < iw-mw; c++ {
				match := true
			MATCH:
				for mr := 0; mr < mh; mr++ {
					for mc := 0; mc < mw; mc++ {
						if monster[mr][mc] != '#' {
							continue
						}
						if image[r+mr][c+mc] != '#' {
							match = false
							break MATCH
						}
					}
				}
				if !match {
					continue
				}
				mchars += monsterSize
			}
		}
		if i == 3 {
			image = ReverseStringList(image)
		} else {
			image = RotateStrings(image)
		}
	}

	c := 0
	for _, line := range image {
		for _, ch := range line {
			if ch == '#' {
				c++
			}
		}
	}
	return c - mchars
}

func main() {
	chunks := InputChunks(input)
	p1 := NewWater(chunks).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewWater(chunks).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
