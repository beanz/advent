package main

import (
	"bytes"
	_ "embed"
	"fmt"
	"os"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Dir int

const (
	UP    Dir = 1
	RIGHT Dir = 2
	DOWN  Dir = 4
	LEFT  Dir = 8
)

func (d Dir) String() string {
	switch d {
	case UP:
		return "^"
	case DOWN:
		return "v"
	case LEFT:
		return "<"
	case RIGHT:
		return ">"
	}
	return "?"
}

func CW(d Dir) Dir {
	if d == LEFT {
		return UP
	}
	return d << 1
}

func CCW(d Dir) Dir {
	if d == UP {
		return LEFT
	}
	return d >> 1
}

func (b beam) mov() beam {
	switch b.d {
	case UP:
		return beam{b.x, b.y - 1, b.d}
	case RIGHT:
		return beam{b.x + 1, b.y, b.d}
	case DOWN:
		return beam{b.x, b.y + 1, b.d}
	case LEFT:
		return beam{b.x - 1, b.y, b.d}
	}
	panic("unreachable mov")
}

type beam struct {
	x, y int
	d    Dir
}

func Solve(m *ByteMap, x, y int, d Dir) int {
	todo := []beam{{x, y, d}}
	seen := [14000]Dir{}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if cur.x < 0 || cur.x >= m.Width() || cur.y < 0 || cur.y >= m.Height() {
			continue
		}
		i := m.XYToIndex(cur.x, cur.y)
		if seen[i]&cur.d != 0 {
			continue
		}
		seen[i] |= cur.d
		//pp(m, seen, cur)
		switch m.GetXY(cur.x, cur.y) {
		case '.':
			todo = append(todo, cur.mov())
		case '/':
			switch cur.d {
			case UP:
				todo = append(todo, beam{cur.x + 1, cur.y, RIGHT})
			case RIGHT:
				todo = append(todo, beam{cur.x, cur.y - 1, UP})
			case DOWN:
				todo = append(todo, beam{cur.x - 1, cur.y, LEFT})
			case LEFT:
				todo = append(todo, beam{cur.x, cur.y + 1, DOWN})
			}
		case '\\':
			switch cur.d {
			case UP:
				todo = append(todo, beam{cur.x - 1, cur.y, LEFT})
			case RIGHT:
				todo = append(todo, beam{cur.x, cur.y + 1, DOWN})
			case DOWN:
				todo = append(todo, beam{cur.x + 1, cur.y, RIGHT})
			case LEFT:
				todo = append(todo, beam{cur.x, cur.y - 1, UP})
			}
		case '|':
			switch cur.d {
			case UP, DOWN:
				todo = append(todo, cur.mov())
			case RIGHT, LEFT:
				todo = append(todo,
					beam{cur.x, cur.y - 1, UP},
					beam{cur.x, cur.y + 1, DOWN},
				)
			}
		case '-':
			switch cur.d {
			case LEFT, RIGHT:
				todo = append(todo, cur.mov())
			case UP, DOWN:
				todo = append(todo,
					beam{cur.x - 1, cur.y, LEFT},
					beam{cur.x + 1, cur.y, RIGHT},
				)
			}
		}
	}
	c := 0
	for _, e := range seen {
		if e != 0 {
			c++
		}
	}
	return c
}

func pp(m *ByteMap, seen [14000]Dir, cur beam) {
	var b bytes.Buffer
	for y := 0; y < m.Height(); y++ {
		for x := 0; x < m.Width(); x++ {
			if cur.x == x && cur.y == y {
				fmt.Fprint(&b, cur.d.String())
				continue
			}
			i := m.XYToIndex(x, y)
			ch := m.Get(i)
			if seen[i] != 0 {
				fmt.Fprint(&b, Bold(string(ch)))
				continue
			}
			b.WriteByte(ch)
		}
		b.WriteByte('\n')
	}
	fmt.Fprintln(os.Stderr, b.String())
}

func Parts(in []byte, args ...int) (int, int) {
	m := NewByteMap(in)
	p1 := Solve(m, 0, 0, RIGHT)
	p2 := 0
	for x := 0; x < m.Width(); x++ {
		s := Solve(m, x, 0, DOWN)
		if s > p2 {
			p2 = s
		}
		s = Solve(m, x, m.Height()-1, UP)
		if s > p2 {
			p2 = s
		}
	}
	for y := 0; y < m.Height(); y++ {
		s := Solve(m, 0, y, RIGHT)
		if s > p2 {
			p2 = s
		}
		s = Solve(m, m.Width()-1, y, LEFT)
		if s > p2 {
			p2 = s
		}
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
