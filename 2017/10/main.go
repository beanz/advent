package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Rope struct {
	twists []int
	rope   []int
	cur    int
	skip   int
	debug  bool
}

func (r *Rope) String() string {
	s := []string{}
	for i := 0; i < len(r.rope); i++ {
		if r.cur == i {
			s = append(s, fmt.Sprintf("[%d]", r.rope[i]))
		} else {
			s = append(s, fmt.Sprintf("%d", r.rope[i]))
		}
	}
	return strings.Join(s, " ")
}

func NewRope(line string, rlen int) *Rope {
	nums := ReadInts(strings.Split(line, ","))
	rope := []int{}
	for i := 0; i < rlen; i++ {
		rope = append(rope, i)
	}
	return &Rope{nums, rope, 0, 0, false}
}

func NewPart2Rope(line string, rlen int) *Rope {
	nums := []int{}
	for _, ch := range strings.Split(line, "") {
		nums = append(nums, int(byte(ch[0])))
	}
	nums = append(nums, 17, 31, 73, 47, 23)
	rope := []int{}
	for i := 0; i < rlen; i++ {
		rope = append(rope, i)
	}
	return &Rope{nums, rope, 0, 0, false}
}

func (r *Rope) Twist(twistlen int) {
	rl := len(r.rope)
	for i := 0; i < twistlen/2; i++ {
		j := twistlen - 1 - i
		if i == j {
			continue
		}
		ri := (i + r.cur) % rl
		rj := (j + r.cur) % rl
		r.rope[ri], r.rope[rj] = r.rope[rj], r.rope[ri]
	}
	r.cur = (r.cur + twistlen + r.skip) % len(r.rope)
	r.skip++
}

func (r *Rope) DenseHash() string {
	nums := []string{}
	for i := 0; i < 256; i += 16 {
		chk := 0
		for j := 0; j < 16; j++ {
			chk ^= r.rope[i+j]
		}
		nums = append(nums, fmt.Sprintf("%02x", chk))
	}
	return strings.Join(nums, "")
}

func (r *Rope) Part1() int {
	for _, t := range r.twists {
		r.Twist(t)
	}
	return r.rope[0] * r.rope[1]
}

func (r *Rope) Part2() string {
	for i := 0; i < 64; i++ {
		r.Part1()
	}
	return r.DenseHash()
}

func main() {
	p1 := NewRope(InputLines(input)[0], 256).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewPart2Rope(InputLines(input)[0], 256).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
