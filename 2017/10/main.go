package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

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

func NewRope(file string, rlen int) *Rope {
	line := ReadLines(file)[0]
	nums, err := ReadInts(strings.Split(line, ","))
	if err != nil {
		log.Fatalf("Invalid int in line: %s\n", err)
	}
	rope := []int{}
	for i := 0; i < rlen; i++ {
		rope = append(rope, i)
	}
	return &Rope{nums, rope, 0, 0, false}
}

func NewPart2Rope(file string, rlen int) *Rope {
	line := ReadLines(file)[0]
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

func (r *Rope) Twist(pos int) {
	n := []int{}
	for i := 0; i < len(r.rope); i++ {
		offset := ((len(r.rope) + i) - r.cur) % len(r.rope)
		if r.debug {
			fmt.Printf("%d: offset=%d ", i, offset)
		}
		if offset >= pos {
			n = append(n, r.rope[i])
			if r.debug {
				fmt.Printf("%d\n", i)
			}
		} else {
			altOffset := (pos - 1) - offset
			alt := (r.cur + altOffset) % len(r.rope)
			if r.debug {
				fmt.Printf("%d => %d => %d\n", i, altOffset, alt)
			}
			n = append(n, r.rope[alt])
		}
	}
	r.cur = (r.cur + pos + r.skip) % len(r.rope)
	r.skip++
	r.rope = n
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	fmt.Printf("Part 1: %d\n", NewRope(os.Args[1], 256).Part1())
	fmt.Printf("Part 2: %s\n", NewPart2Rope(os.Args[1], 256).Part2())
}