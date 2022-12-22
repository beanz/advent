package main

import (
	_ "embed"
	"fmt"
	"strings"
	"time"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Dir int

const (
	Right Dir = iota
	Down
	Left
	Up
	MaxDir
)

func (d Dir) Inc() (int, int) {
	switch d {
	case Right:
		return 1, 0
	case Down:
		return 0, 1
	case Left:
		return -1, 0
	case Up:
		return 0, -1
	default:
		panic("unreachable")
	}

}

func (d Dir) String() string {
	switch d {
	case Right:
		return ">"
	case Down:
		return "v"
	case Left:
		return "<"
	case Up:
		return "^"
	default:
		panic("unreachable")
	}
}

const (
	Wall    = '#'
	Empty   = '.'
	Invalid = ' '
)

type Pos struct {
	x, y int
	dir  Dir
}

func (p Pos) Password() int {
	return 1000*(p.y+1) + 4*(p.x+1) + int(p.dir)
}

type Map [][]byte

type Next struct {
	face int
	dir  Dir
}

type Board struct {
	m       *Map
	initPos Pos
	p       Pos
	walk    []byte
	walk_i  int
	w, h    int

	// Part 2 stuff
	dim  int
	face [6][2]int
	next [6][4]Next
}

var (
	testDim   = 4
	testFaces = [6][2]int{
		{2, 0}, {0, 1}, {1, 1}, {2, 1}, {2, 2}, {3, 2},
	}
	testNext = [6][4]Next{
		{{5, Left}, {3, Down}, {2, Down}, {1, Down}},
		{{2, Right}, {4, Up}, {5, Up}, {0, Down}},
		{{3, Right}, {4, Right}, {1, Left}, {0, Right}},
		{{5, Down}, {4, Down}, {2, Left}, {0, Up}},
		{{5, Right}, {1, Up}, {2, Up}, {3, Up}},
		{{0, Left}, {1, Right}, {4, Left}, {3, Left}},
	}
	inputDim   = 50
	inputFaces = [6][2]int{
		{1, 0}, {2, 0}, {1, 1}, {0, 2}, {1, 2}, {0, 3},
	}
	inputNext = [6][4]Next{
		{{1, Right}, {2, Down}, {3, Right}, {5, Right}},
		{{4, Left}, {2, Left}, {0, Left}, {5, Up}},
		{{1, Up}, {4, Down}, {3, Down}, {0, Up}},
		{{4, Right}, {5, Down}, {0, Right}, {2, Right}},
		{{1, Left}, {5, Left}, {3, Left}, {2, Up}},
		{{4, Up}, {1, Down}, {0, Down}, {3, Up}},
	}
)

func (b *Board) Get(x, y int) byte {
	if y >= b.h {
		panic("out of bounds y")
	}
	if x > b.w {
		panic("out of bounds x")
	}
	if x >= len((*b.m)[y]) {
		return Invalid
	}
	return (*b.m)[y][x]
}

func (b *Board) String() string {
	var sb strings.Builder
	for y := 0; y < b.h; y++ {
		for x := 0; x < b.w; x++ {
			if x == b.p.x && y == b.p.y {
				fmt.Printf("%s", b.p.dir)
				continue
			}
			fmt.Printf("%c", b.Get(x, y))
		}
		fmt.Println(&sb)
	}
	fmt.Println(&sb)
	return sb.String()
}

func (b *Board) Move() bool {
	ix, iy := b.p.dir.Inc()
	nx, ny := Mod(b.p.x+ix, b.w), Mod(b.p.y+iy, b.h)
	sq := b.Get(nx, ny)
	//fmt.Printf("%v => %d,%d %v %v\n", b.p, nx, ny, sq, sq == Empty)
	for sq == Invalid {
		nx, ny = Mod(nx+ix, b.w), Mod(ny+iy, b.h)
		sq = b.Get(nx, ny)
	}
	if sq != Empty {
		return true
	}
	b.p.x = nx
	b.p.y = ny
	return false
}

func (b *Board) Move2() bool {
	cx, cy, face := b.Face(b.p.x, b.p.y)
	ix, iy := b.p.dir.Inc()
	ncx, ncy := cx+ix, cy+iy
	ndir := b.p.dir
	if ncy < 0 {
		nxt := b.next[face][Up]
		face, ndir = nxt.face, nxt.dir
		ncx, ncy = b.Wrap(ncx, ncy, b.p.dir, ndir)
	}
	if ncy == b.dim {
		nxt := b.next[face][Down]
		face, ndir = nxt.face, nxt.dir
		ncx, ncy = b.Wrap(ncx, ncy, b.p.dir, ndir)
	}
	if ncx < 0 {
		nxt := b.next[face][Left]
		face, ndir = nxt.face, nxt.dir
		ncx, ncy = b.Wrap(ncx, ncy, b.p.dir, ndir)
	}
	if ncx == b.dim {
		nxt := b.next[face][Right]
		face, ndir = nxt.face, nxt.dir
		ncx, ncy = b.Wrap(ncx, ncy, b.p.dir, ndir)
	}
	nx, ny := b.Flat(ncx, ncy, face)
	if b.Get(nx, ny) != Empty {
		return true
	}
	b.p.x = nx
	b.p.y = ny
	b.p.dir = ndir
	return false
}

func (b *Board) Part(moveFn func() bool) int {
	b.walk_i = 0
	b.p = b.initPos
	for b.walk_i < len(b.walk) {
		if b.walk[b.walk_i] == 'L' {
			b.walk_i++
			b.p.dir--
			if b.p.dir < Right {
				b.p.dir = Up
			}
			continue
		} else if b.walk[b.walk_i] == 'R' {
			b.walk_i++
			b.p.dir++
			if b.p.dir > Up {
				b.p.dir = Right
			}
			continue
		}
		n := int(b.walk[b.walk_i] - '0')
		b.walk_i++
		if b.walk_i < len(b.walk) && '0' <= b.walk[b.walk_i] && b.walk[b.walk_i] <= '9' {
			n = n*10 + int(b.walk[b.walk_i]-'0')
			b.walk_i++
		}
		for k := 0; k < n; k++ {
			blocked := moveFn()
			if VISUAL() {
				fmt.Printf("%s\n", b.String())
				time.Sleep(500 * time.Millisecond)
			}
			if blocked {
				break
			}
		}
	}
	return b.p.Password()
}

func (b *Board) Wrap(x, y int, old, new Dir) (int, int) {
	if old == new {
		switch old {
		case Up:
			return x, b.dim - 1
		case Down:
			return x, 0
		case Left:
			return b.dim - 1, y
		case Right:
			return 0, y
		}
	}
	if old == Up && new == Right {
		return 0, x
	}
	if old == Down && new == Up {
		return b.dim - 1 - x, b.dim - 1
	}
	if old == Right && new == Down {
		return b.dim - 1 - y, 0
	}
	if old == Down && new == Left {
		return b.dim - 1, x
	}
	if old == Left && new == Down {
		return y, 0
	}
	if old == Left && new == Right {
		return 0, b.dim - 1 - y
	}
	if old == Right && new == Left {
		return b.dim - 1, b.dim - 1 - y
	}
	if old == Right && new == Up {
		return y, b.dim - 1
	}
	panic("unreachable")
}

func (b *Board) Flat(x, y, face int) (int, int) {
	cx, cy := b.face[face][0], b.face[face][1]
	return cx*b.dim + x, cy*b.dim + y
}

func (b *Board) Face(x, y int) (int, int, int) {
	cx, cy := x/b.dim, y/b.dim
	x %= b.dim
	y %= b.dim
	return x, y, b.FaceFor(cx, cy)
}

func (b *Board) FaceFor(cx, cy int) int {
	for i, f := range b.face {
		if f[0] == cx && f[1] == cy {
			return i
		}
	}
	panic("unreachable")
}

func Parts(in []byte) (int, int) {
	m := make(Map, 0, 200)
	i := 0
	w := 0
	h := 0
	for i < len(in) && in[i] != '\n' {
		j := ChompToNextLine(in, i)
		l := in[i : j-1]
		m = append(m, l)
		if len(l) > w {
			w = len(l)
		}
		h++
		i = j
	}
	walk := in[i+1 : len(in)-1]
	x := 0
	for ; m[0][x] == ' '; x++ {
	}
	pos := Pos{x, 0, Right}
	//fmt.Printf("%v\n", pos)
	//fmt.Printf("%d x %d\n", w, h)
	//fmt.Printf("%s\n", walk)
	var faces [6][2]int
	var dim int
	var next [6][4]Next
	if h == 12 { // test
		faces = testFaces
		dim = testDim
		next = testNext
	} else { // input
		faces = inputFaces
		dim = inputDim
		next = inputNext
	}
	b := Board{&m, pos, pos, walk, 0, w, h, dim, faces, next}
	//fmt.Printf("%s\n", b.String())
	return b.Part(b.Move), b.Part(b.Move2)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
