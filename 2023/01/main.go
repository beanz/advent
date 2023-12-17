package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func digit1(in []byte) int {
	if len(in) < 1 {
		return 0
	}
	switch in[0] {
	case '\n':
		return -1
	case '1':
		return 1
	case '2':
		return 2
	case '3':
		return 3
	case '4':
		return 4
	case '5':
		return 5
	case '6':
		return 6
	case '7':
		return 7
	case '8':
		return 8
	case '9':
		return 9
	}
	return 0
}

func digit2(in []byte) int {
	if len(in) < 1 {
		return 0
	}
	switch in[0] {
	case 'o':
		if len(in) >= 3 && in[1] == 'n' && in[2] == 'e' {
			return 1
		}
	case 't':
		if len(in) >= 3 && in[1] == 'w' && in[2] == 'o' {
			return 2
		}
		if len(in) >= 5 && in[1] == 'h' && in[2] == 'r' && in[3] == 'e' && in[4] == 'e' {
			return 3
		}
	case 'f':
		if len(in) >= 4 && in[1] == 'o' && in[2] == 'u' && in[3] == 'r' {
			return 4
		}
		if len(in) >= 4 && in[1] == 'i' && in[2] == 'v' && in[3] == 'e' {
			return 5
		}
	case 's':
		if len(in) >= 3 && in[1] == 'i' && in[2] == 'x' {
			return 6
		}
		if len(in) >= 5 && in[1] == 'e' && in[2] == 'v' && in[3] == 'e' && in[4] == 'n' {
			return 7
		}
	case 'e':
		if len(in) >= 5 && in[1] == 'i' && in[2] == 'g' && in[3] == 'h' && in[4] == 't' {
			return 8
		}
	case 'n':
		if len(in) >= 4 && in[1] == 'i' && in[2] == 'n' && in[3] == 'e' {
			return 9
		}
	}
	return 0
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	first, last := 0, 0
	first2, last2 := 0, 0
	for i := 0; i < len(in); i++ {
		d := digit1(in[i:])
		if d == -1 {
			p1 += first*10 + last
			first, last = 0, 0
			p2 += first2*10 + last2
			first2, last2 = 0, 0
			continue
		}
		if d != 0 {
			if first == 0 {
				first = d
			}
			last = d
			if first2 == 0 {
				first2 = d
			}
			last2 = d
			continue
		}
		d = digit2(in[i:])
		if d != 0 {
			if first2 == 0 {
				first2 = d
			}
			last2 = d
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
