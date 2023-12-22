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

type Dir int8

const (
	UP    Dir = 1
	RIGHT Dir = 2
	DOWN  Dir = 4
	LEFT  Dir = 8
)

func (d Dir) X() int16 {
	if d == LEFT {
		return -1
	} else if d == RIGHT {
		return 1
	}
	return 0
}

func (d Dir) Y() int16 {
	if d == UP {
		return -1
	} else if d == DOWN {
		return 1
	}
	return 0
}

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
	return beam{b.x + b.d.X(), b.y + b.d.Y(), b.d}
}

type beam struct {
	x, y int16
	d    Dir
}

func Solve(m *ByteMap, todo []beam) int {
	seen := [14000]Dir{}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if cur.x < 0 || int(cur.x) >= m.Width() || cur.y < 0 || int(cur.y) >= m.Height() {
			continue
		}
		i := m.XYToIndex(int(cur.x), int(cur.y))
		if seen[i]&cur.d != 0 {
			continue
		}
		seen[i] |= cur.d
		//pp(m, seen, cur)
		switch m.GetXY(int(cur.x), int(cur.y)) {
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
	//pp(m, seen, beam{-1, -1, 0})
	return c
}

func pp(m *ByteMap, seen [14000]Dir, cur beam) { // nolint:unused
	var b bytes.Buffer
	for y := int16(0); y < int16(m.Height()); y++ {
		for x := int16(0); x < int16(m.Width()); x++ {
			if cur.x == x && cur.y == y {
				fmt.Fprint(&b, cur.d.String())
				continue
			}
			i := m.XYToIndex(int(x), int(y))
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
	todo := make([]beam, 0, 2048)
	todo = append(todo, beam{0, 0, RIGHT})
	p1 := Solve(m, todo)
	p2 := 0
	for x := int16(0); x < int16(m.Width()); x++ {
		todo = todo[:0]
		todo = append(todo, beam{x, 0, DOWN})
		s := Solve(m, todo)
		if s > p2 {
			p2 = s
		}
		todo = todo[:0]
		todo = append(todo, beam{x, int16(m.Height() - 1), UP})
		s = Solve(m, todo)
		if s > p2 {
			p2 = s
		}
	}
	for y := 0; y < m.Height(); y++ {
		todo = todo[:0]
		todo = append(todo, beam{0, int16(y), RIGHT})
		s := Solve(m, todo)
		if s > p2 {
			p2 = s
		}
		todo = todo[:0]
		todo = append(todo, beam{int16(m.Width() - 1), int16(y), LEFT})
		s = Solve(m, todo)
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
