package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1a, p1p := 0, 0
	p2a, p2p := 0, 0
	x1, y1 := 0, 0
	x2, y2 := 0, 0
	for i := 0; i < len(in); i++ {
		ox, oy := oxoy(in[i])
		j, n := ChompUInt[int](in, i+2)
		i = j + 3
		nx, ny := x1+ox*n, y1+oy*n
		p1a += (x1 - nx) * (y1 + ny)
		p1p += n
		x1, y1 = nx, ny
		ox, oy = oxoy(in[i+5])
		n = hex(in[i : i+5])
		nx, ny = x2+ox*n, y2+oy*n
		p2a += (x2 - nx) * (y2 + ny)
		p2p += n
		x2, y2 = nx, ny
		i += 7
	}
	return (Abs(p1a) + p1p + 2) / 2, (Abs(p2a) + p2p + 2) / 2
}

func hex(in []byte) int {
	n := 0
	for _, ch := range in {
		var d int
		switch ch {
		case 'a', 'b', 'c', 'd', 'e', 'f':
			d = int(10 + ch - 'a')
		default:
			d = int(ch - '0')
		}
		n = 16*n + d
	}
	return n
}

func oxoy(ch byte) (int, int) {
	switch ch {
	case 'R', '0':
		return 1, 0
	case 'D', '1':
		return 0, 1
	case 'L', '2':
		return -1, 0
	//case 'U', '3':
	default:
		return 0, -1
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
