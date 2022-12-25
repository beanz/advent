package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const MAX_LEN = 20

func Part(in []byte) [MAX_LEN]byte {
	s := 0
	n := 0
	for _, ch := range in {
		switch ch {
		case '\n':
			s += n
			n = 0
		case '2':
			n = 5*n + 2
		case '1':
			n = 5*n + 1
		case '0':
			n = 5*n + 0
		case '-':
			n = 5*n - 1
		case '=':
			n = 5*n - 2
		}
	}
	return Snafu(s)
}

func Snafu(n int) [MAX_LEN]byte {
	res := [MAX_LEN]byte{}
	l := MAX_LEN - 1
	for {
		m := n % 5
		switch m {
		case 0:
			res[l] = '0'
			n /= 5
		case 1:
			res[l] = '1'
			n /= 5
		case 2:
			res[l] = '2'
			n /= 5
		case 3:
			res[l] = '='
			n = (n + 2) / 5
		case 4:
			res[l] = '-'
			n = (n + 1) / 5
		}
		l--
		if n == 0 {
			break
		}
	}
	for l >= 0 {
		res[l] = 32
		l--
	}
	return res
}

func main() {
	p1 := Part(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
}

var benchmark = false
