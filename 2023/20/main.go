package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const HI = true
const LO = false

const (
	BUTTON int = iota
	BCASTER
	OUTPUT
	NAND
	NOT
)
const SIZE = 26*26 + OUTPUT

type pulse struct {
	sig bool
	dst int
}

func Parts(in []byte, args ...int) (int, int) {
	outputs := make([][]int, SIZE)
	kind := make([]byte, SIZE)
	inputs := make([][]int, SIZE)
	outputs[BUTTON] = []int{BCASTER}
	i := 0
	for i < len(in) {
		k, id := chompKindID(in, &i)
		kind[id] = byte(k)
		i += 2
		for in[i] != '\n' {
			i += 2
			oid := chompID(in, &i)
			outputs[id] = append(outputs[id], oid)
			inputs[oid] = append(inputs[oid], id)
		}
		i += 1
	}

	cHi, cLo := 0, 0
	flip := make([]bool, SIZE)
	nand := make([][]bool, SIZE)
	fired := make([]int, SIZE)
	for j := 0; j < SIZE; j++ {
		if kind[j] == byte(NAND) {
			nand[j] = make([]bool, len(inputs[j]))
		}
	}
	pretty := func(id int) string {
		switch id {
		case BUTTON:
			return "button"
		case BCASTER:
			return "broadcaster"
		case OUTPUT:
			return "output"
		default:
			i := id - NAND
			return fmt.Sprintf("%c%c", byte(i/26+'a'), byte(i%26+'a'))
		}
	}
	_ = pretty(BUTTON)
	cycle := func(c int) {
		todo := make([]pulse, 1, 512)
		todo[0] = pulse{LO, BUTTON}
		for len(todo) > 0 {
			cur := todo[0]
			todo = todo[1:]
			sig := cur.sig
			dst := cur.dst
			if cur.dst == OUTPUT {
				continue
			}
			for _, out := range outputs[dst] {
				if sig {
					cHi++
				} else {
					cLo++
				}
				//fmt.Fprintf(os.Stderr, "%s %v> %s\n", pretty(dst), sig, pretty(out))
				if kind[out] == byte(BCASTER) {
					todo = append(todo, pulse{sig, out})
					continue
				}
				if kind[out] == byte(NOT) {
					if sig == LO { // nolint:gosimple
						flip[out] = !flip[out]
						todo = append(todo, pulse{flip[out], out})
					}
					continue
				}
				nsig := HI
				for k := 0; k < len(nand[out]); k++ {
					if inputs[out][k] == dst {
						nand[out][k] = sig
					}
					nsig = nsig && nand[out][k]
				}
				if nsig {
					todo = append(todo, pulse{LO, out})
				} else {
					fired[out] = c + 1
					todo = append(todo, pulse{HI, out})
				}
			}
		}
	}
	c := 0
	for ; c < 1000; c++ {
		cycle(c)
	}

	//fmt.Fprintf(os.Stderr, "%d x %d\n", cLo, cHi)
	p1 := cLo * cHi

	k := 0
	rxID := chompID([]byte("rx"), &k)
	if len(inputs[rxID]) == 0 {
		return p1, 0
	}
	important := inputs[inputs[rxID][0]]
	//fmt.Fprintf(os.Stderr, "%v\n", important)
	for ; ; c++ {
		cycle(c)
		var found = true
		for _, k := range important {
			if fired[k] == 0 {
				found = false
				break
			}
		}
		if found {
			break
		}
	}
	p2 := 1
	for _, k := range important {
		p2 *= fired[k]
	}
	return p1, p2
}

func chompKindID(in []byte, i *int) (int, int) {
	if in[*i+2] == 'o' {
		*i += 11
		return BCASTER, BCASTER
	}
	if in[*i] == '%' {
		*i++
		return NOT, chompID(in, i)
	} else if in[*i] == '&' {
		*i++
		return NAND, chompID(in, i)
	}
	panic("expected kind and id")
}

func chompID(in []byte, i *int) int {
	if *i+2 < len(in) && in[*i+2] == 't' {
		*i += 6
		return OUTPUT
	}
	if in[*i+1] < 'a' {
		id := NAND + int(in[*i]-'a')
		*i++
		return id
	}
	id := NAND + int(in[*i]-'a')*26 + int(in[*i+1]-'a')
	*i += 2
	return id
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
