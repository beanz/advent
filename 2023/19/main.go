package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Check struct {
	key int
	op  byte
	val int
	nxt int
}

const IN = 442 // ChompAZ of 'in'

const (
	STATE int = iota
	XLO
	XHI
	MLO
	MHI
	ALO
	AHI
	SLO
	SHI
)

func Parts(in []byte, args ...int) (int, int) {
	i := 0
	rules := make(map[int][]Check, 512)
	for ; i < len(in); i++ {
		id := ChompAZ(in, &i)
		rules[id] = make([]Check, 0, 4)
		for in[i] != '}' {
			i++ // skip '{' or ','
			if in[i+1] != '<' && in[i+1] != '>' {
				nxt := ChompAZ(in, &i)
				rules[id] = append(rules[id], Check{nxt: nxt})
				break
			}
			j, val := ChompUInt[int](in, i+2)
			c := Check{key: key(in[i]), op: in[i+1], val: val}
			i = j + 1
			c.nxt = ChompAZ(in, &i)
			rules[id] = append(rules[id], c)
		}
		i += 1 // skip }
		if i+1 < len(in) && in[i+1] == '\n' {
			break
		}
	}
	//fmt.Fprintf(os.Stderr, "R: %v\n", rules)
	i += 2
	p1 := 0
	for ; i < len(in); i++ {
		p := [4]int{}
		k := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			p[k] = n
			k++
		})
		//fmt.Fprintf(os.Stderr, "P: %v\n", p)

		state := IN
		for {
			if state == 0 {
				break
			}
			if state == 1 {
				p1 += p[0] + p[1] + p[2] + p[3]
				break
			}
			for _, chk := range rules[state] {
				if chk.op == 0 {
					state = chk.nxt
					break
				}
				if chk.op == '<' {
					if p[chk.key] < chk.val {
						state = chk.nxt
						break
					}
					continue
				}
				if p[chk.key] > chk.val {
					state = chk.nxt
					break
				}
			}
		}
		i++ // skip }
	}
	p2 := 0
	todo := make([][9]int, 1, 512)
	todo[0] = [9]int{IN, 1, 4000, 1, 4000, 1, 4000, 1, 4000}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		state := cur[STATE]
		if state == 0 {
			continue // reject
		}
		if state == 1 {
			p2 += (cur[XHI] - cur[XLO] + 1) * (cur[MHI] - cur[MLO] + 1) * (cur[AHI] - cur[ALO] + 1) * (cur[SHI] - cur[SLO] + 1)
			continue
		}
		for _, chk := range rules[state] {
			if chk.op == 0 {
				todo = append(todo, [9]int{chk.nxt,
					cur[XLO], cur[XHI],
					cur[MLO], cur[MHI],
					cur[ALO], cur[AHI],
					cur[SLO], cur[SHI],
				})
				continue
			}
			ntrue := [9]int{chk.nxt,
				cur[XLO], cur[XHI],
				cur[MLO], cur[MHI],
				cur[ALO], cur[AHI],
				cur[SLO], cur[SHI],
			}
			if chk.op == '>' {
				if chk.val+1 > ntrue[1+chk.key*2] {
					ntrue[1+chk.key*2] = chk.val + 1
				}
				if chk.val < cur[1+chk.key*2+1] {
					cur[1+chk.key*2+1] = chk.val
				}
			} else {
				if chk.val-1 < ntrue[1+chk.key*2+1] {
					ntrue[1+chk.key*2+1] = chk.val - 1
				}
				if chk.val > cur[1+chk.key*2] {
					cur[1+chk.key*2] = chk.val
				}
			}
			todo = append(todo, ntrue)
		}
	}
	return p1, p2
}

func key(ch byte) int {
	switch ch {
	case 'x':
		return 0
	case 'm':
		return 1
	case 'a':
		return 2
	default: // hopefully 's'
		return 3
	}
}

func ChompAZ(in []byte, i *int) int {
	var id int
	for *i < len(in) {
		ch := in[*i]
		if ch == 'R' {
			*i++
			return 0
		}
		if ch == 'A' {
			*i++
			return 1
		}
		if 'a' <= ch && ch <= 'z' {
			id = 26*id + int(ch-'a')
			*i++
			continue
		}
		break
	}
	return id << 1
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
