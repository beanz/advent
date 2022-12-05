package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const MAX_STACKS = 9
const MAX_CRATES = 60

type Dock [MAX_STACKS * MAX_CRATES * 2]byte

func (d *Dock) String() string {
	var sb strings.Builder
	for i := 0; i < MAX_STACKS*2; i++ {
		o := i * MAX_CRATES
		if d[o] == 0 {
			continue
		}
		fmt.Fprintf(&sb, "%dx%d: %s\n", i, d[o], string(d[o+1:1+o+int(d[o])]))
	}
	return sb.String()
}

func (d *Dock) Add(i int, v byte) {
	o := i * MAX_CRATES
	e := int(d[o]) + 1 + o
	copy(d[o+2:e+1], d[o+1:e])
	d[o+1] = v
	d[o]++
}

func (d *Dock) Top(i int) byte {
	o := i * MAX_CRATES
	if d[o] == 0 {
		return ' '
	}
	return d[int(d[o])+o]
}

func (d *Dock) Move(f, t, n int) {
	fr := f * MAX_CRATES
	to := t * MAX_CRATES
	fe := int(d[fr]) + fr
	te := int(d[to]) + 1 + to
	for i := 0; i < n; i++ {
		d[te+i] = d[fe-i]
	}
	d[fr] -= byte(n)
	d[to] += byte(n)
}

func (d *Dock) Move2(f, t, n int) {
	fr := (MAX_STACKS + f) * MAX_CRATES
	to := (MAX_STACKS + t) * MAX_CRATES
	fe := int(d[fr]) + fr
	te := int(d[to]) + 1 + to
	for i := 0; i < n; i++ {
		d[te+i] = d[fe+i-n+1]
	}
	d[fr] -= byte(n)
	d[to] += byte(n)
}

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

func Parts(in []byte) ([MAX_STACKS]byte, [MAX_STACKS]byte) {
	dock := Dock{}
	i := 0
	j := 0
	for ; i < len(in); i++ {
		if in[i] == '\n' {
			if j == 0 {
				break
			}
			j = 0
			continue
		}
		j++
		if in[i] < 'A' || in[i] > 'Z' {
			continue
		}
		dock.Add((j-1)/4, in[i])
		dock.Add(MAX_STACKS+(j-1)/4, in[i])
	}
	i++
	for ; i < len(in); i++ {
		j, n := NextUInt(in, i+5)
		fr, to := int(in[j+6]-'1'), int(in[j+11]-'1')
		dock.Move(fr, to, n)
		dock.Move2(fr, to, n)
		i = j + 12
	}
	p1 := [MAX_STACKS]byte{}
	p2 := [MAX_STACKS]byte{}
	for i := 0; i < MAX_STACKS; i++ {
		p1[i] = dock.Top(i)
		p2[i] = dock.Top(MAX_STACKS + i)
	}
	return p1, p2
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
