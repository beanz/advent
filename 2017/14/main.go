package main

import (
	_ "embed"
	"fmt"
	"math/bits"
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

func (r *Rope) DenseHash() (string, int, []int) {
	ones := 0
	strs := []string{}
	ints := []int{}
	for i := 0; i < 256; i += 16 {
		chk := 0
		for j := 0; j < 16; j++ {
			chk ^= r.rope[i+j]
		}
		ones += bits.OnesCount(uint(chk))
		strs = append(strs, fmt.Sprintf("%02x", chk))
		ints = append(ints, chk)
	}
	return strings.Join(strs, ""), ones, ints
}

func (r *Rope) AllTwists() int {
	for _, t := range r.twists {
		r.Twist(t)
	}
	return r.rope[0] * r.rope[1]
}

func (r *Rope) KnotHash() (string, int, []int) {
	for i := 0; i < 64; i++ {
		r.AllTwists()
	}
	return r.DenseHash()
}

type Map [][]int

func Part1(in string) (int, *Map) {
	ones := 0
	m := Map{}
	for i := 0; i < 128; i++ {
		r := NewRope(fmt.Sprintf("%s-%d", in, i), 256)
		_, c, ints := r.KnotHash()
		ones += c
		m = append(m, ints)
		//fmt.Printf("%s\n", hash)
	}
	return ones, &m
}

func (m *Map) Connected(p Point, visited map[Point]bool) {
	todo := []Point{p}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		for _, np := range cur.Neighbours() {
			if np.X < 0 || np.Y < 0 || np.X >= 128 || np.Y >= 128 {
				continue
			}
			if !m.Used(np) {
				continue
			}
			if visited[np] {
				continue
			}
			visited[np] = true
			todo = append(todo, np)
		}
	}
}

func (m *Map) Used(p Point) bool {
	v := (*m)[p.Y][p.X/8]
	bit := 1 << uint(7-p.X%8)
	return (v & bit) != 0
}

func Part2(m *Map) int {
	count := 0
	visited := map[Point]bool{}
	for y := 0; y < 128; y++ {
		for x := 0; x < 128; x++ {
			p := Point{x, y}
			if !m.Used(p) {
				continue
			}
			if visited[p] {
				continue
			}
			m.Connected(p, visited)
			visited[p] = true
			count++
		}
	}
	return count
}

func main() {
	ones, m := Part1(InputLines(input)[0])
	if !benchmark {
		fmt.Printf("Part 1: %d\n", ones)
	}
	p2 := Part2(m)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
