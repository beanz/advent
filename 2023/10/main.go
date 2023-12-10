package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const (
	NORTH byte = 1
	SOUTH byte = 2
	EAST  byte = 4
	WEST  byte = 8
)

func offsets(b byte) byte {
	switch b {
	case '|':
		return NORTH | SOUTH
	case '-':
		return EAST | WEST
	case 'L':
		return NORTH | EAST
	case 'J':
		return NORTH | WEST
	case '7':
		return SOUTH | WEST
	case 'F':
		return SOUTH | EAST
	default:
		return 0
	}
}

func Parts(in []byte) (int, int) {
	w := bytes.Index(in, []byte{'\n'})
	start := bytes.Index(in, []byte{'S'})
	w += 1
	var startOffsets byte
	todo := make([][2]int, 0, 512)
	if start > w && 0 != offsets(in[start-w])&SOUTH {
		startOffsets |= NORTH
		todo = append(todo, [2]int{start - w, 1})
	}
	if 0 != offsets(in[start+w])&NORTH {
		startOffsets |= SOUTH
		todo = append(todo, [2]int{start + w, 1})
	}
	if 0 != offsets(in[start-1])&EAST {
		startOffsets |= WEST
		todo = append(todo, [2]int{start - 1, 1})
	}
	if 0 != offsets(in[start+1])&WEST {
		startOffsets |= EAST
		todo = append(todo, [2]int{start + 1, 1})
	}
	//in[start] = startOffsets
	path := [19740]bool{}
	path[start] = true
	p1 := 0
	for len(todo) > 0 {
		cur, steps := todo[0][0], todo[0][1]
		todo = todo[1:]
		if path[cur] {
			continue
		}
		path[cur] = true
		if steps > p1 {
			p1 = steps
		}
		steps++
		o := offsets(in[cur])
		if (o & WEST) != 0 {
			todo = append(todo, [2]int{cur - 1, steps})
		}
		if (o & EAST) != 0 {
			todo = append(todo, [2]int{cur + 1, steps})
		}
		if (o & NORTH) != 0 {
			todo = append(todo, [2]int{cur - w, steps})
		}
		if (o & SOUTH) != 0 {
			todo = append(todo, [2]int{cur + w, steps})
		}
	}
	p2 := 0
	c := 0
	var turn byte
	for i := 0; i < len(in); i++ {
		if in[i] == '\n' {
			//fmt.Fprintln(os.Stderr)
			turn = 0
			c = 0
			continue
		}
		if path[i] {
			//fmt.Fprintf(os.Stderr, "%s", in[i:i+1])
			v := offsets(in[i])
			if i == start {
				v = startOffsets
			}
			turn ^= v
			if (turn & (NORTH | SOUTH)) == (NORTH | SOUTH) {
				c++
				turn = 0
			}
			continue
		}
		//fmt.Fprintf(os.Stderr, "%d", c%2)
		turn = 0
		if (c % 2) == 1 {
			p2++
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
