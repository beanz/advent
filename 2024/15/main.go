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

func Parts(in []byte, args ...int) (int, int) {
	m1, moves, _ := bytes.Cut(in, []byte{'\n', '\n'})
	m2 := make([]byte, 0, 65536)
	for _, ch := range m1 {
		switch ch {
		case '\n':
			m2 = append(m2, '\n')
		case '#':
			m2 = append(m2, '#', '#')
		case '.':
			m2 = append(m2, '.', '.')
		case '@':
			m2 = append(m2, '@', '.')
		case 'O':
			m2 = append(m2, '[', ']')
		}
	}
	return robot(m1, moves, false), robot(m2[:], moves, true)
}

func robot(m []byte, moves []byte, p2 bool) int {
	w := bytes.IndexByte(m, '\n') + 1
	r := bytes.IndexByte(m, '@')
	h := (len(m) + 1) / w // add one for missing \n
	rx := r % w
	ry := r / w
	w--
	get := func(x, y int) byte {
		ch := m[x+y*(w+1)]
		if ch == '@' {
			return '.'
		}
		return ch
	}
	set := func(x, y int, ch byte) {
		m[x+y*(w+1)] = ch
	}

	boxes := make([]box, 0, 1024)
	check := make([][2]int, 0, 128)
	ncheck := make([][2]int, 0, 128)
	for _, m := range moves {
		if m == '\n' {
			continue
		}
		dx, dy := dir(m)
		nx, ny := rx+dx, ry+dy
		ch := get(nx, ny)
		if ch == '#' {
			continue
		}
		if ch == '.' {
			rx, ry = nx, ny
			continue
		}
		move := true
		if p2 && dx == 0 {
			check = append(check, [2]int{rx, ry})
			ncheck = ncheck[:0]
			for len(check) > 0 {
				for _, c := range check {
					cx, cy := c[0], c[1]+dy
					ch := get(cx, cy)
					if ch == '#' {
						move = false
						break
					} else if ch == '[' {
						ncheck = append(ncheck, [2]int{cx, cy})
						boxes = append(boxes, box{cx, cy, ch})
						ncheck = append(ncheck, [2]int{cx + 1, cy})
						boxes = append(boxes, box{cx + 1, cy, ']'})
					} else if ch == ']' {
						ncheck = append(ncheck, [2]int{cx, cy})
						boxes = append(boxes, box{cx, cy, ch})
						ncheck = append(ncheck, [2]int{cx - 1, cy})
						boxes = append(boxes, box{cx - 1, cy, '['})
					}
				}
				check, ncheck = ncheck, check[:0]
			}
		} else {
			tx, ty := nx, ny
			for {
				ch := get(tx, ty)
				if ch == '#' {
					move = false
					break
				}
				if ch == '.' {
					break
				}
				boxes = append(boxes, box{tx, ty, ch})
				tx, ty = tx+dx, ty+dy
			}
		}
		if !move {
			boxes = boxes[:0]
			continue
		}
		for _, b := range boxes {
			set(b.x, b.y, '.')
		}
		for _, b := range boxes {
			set(b.x+dx, b.y+dy, b.ch)
		}
		boxes = boxes[:0]
		rx, ry = nx, ny
	}
	return score(m, w, h)
}

type box struct {
	x, y int
	ch   byte
}

func PP(m []byte, w, h, sx, sy int) {
	var b bytes.Buffer
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			if x == sx && y == sy {
				b.WriteByte('@')
			} else {
				b.WriteByte(m[x+y*(w+1)])
			}
		}
		b.WriteByte('\n')
	}
	fmt.Fprint(os.Stderr, b.String())
}

func score(m []byte, w, h int) int {
	sc := 0
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			ch := m[x+y*(w+1)]
			if ch == 'O' || ch == '[' {
				sc += y*100 + x
			}
		}
	}
	return sc
}

func dir(ch byte) (int, int) {
	switch ch {
	case '^':
		return 0, -1
	case '>':
		return 1, 0
	case 'v':
		return 0, 1
	case '<':
		return -1, 0
	default:
		panic("invalid dir")
	}
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
