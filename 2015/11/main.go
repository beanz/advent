package main

import (
	"fmt"

	. "github.com/beanz/advent2015/lib"
)

type PW struct {
	b []byte
	l int
}

func NewPW(pw string) *PW {
	b := make([]byte, len(pw)+10)
	copy(b, []byte(pw))
	return &PW{b: b, l: len(pw)}
}

func (pw *PW) Bytes() []byte {
	return pw.b[:pw.l]
}

func (pw *PW) String() string {
	return string(pw.Bytes())
}

func (pw *PW) Inc() {
	for i := pw.l - 1; i >= 0; i-- {
		pw.b[i]++
		if pw.b[i] <= 'z' {
			return
		}
		pw.b[i] = 'a'
	}
	pw.b[0] = 'a'
	pw.b[pw.l] = 'a'
	pw.l++
}

func Valid(pw string) bool {
	seen := make(map[string]bool, len(pw)/2)
	hasStraight := false
	hasBad := false
	numPairs := 0
	for i := 0; i < len(pw); i++ {
		if pw[i] == 'i' || pw[i] == 'o' || pw[i] == 'l' {
			hasBad = true
			break
		}
		if i == len(pw)-1 {
			continue
		}
		if pw[i] == pw[i+1] && !seen[""+string(pw[i:i+2])] {
			seen[""+string(pw[i:i+2])] = true
			numPairs++
		}
		if i == len(pw)-2 || hasStraight {
			continue
		}
		if pw[i] == pw[i+1]-1 && pw[i] == pw[i+2]-2 {
			hasStraight = true
		}
	}
	return hasStraight && !hasBad && numPairs >= 2
}

func Next(cur string) string {
	pw := NewPW(cur)
	pw.Inc()
	for ; !Valid(pw.String()); pw.Inc() {
	}
	return pw.String()
}

func main() {
	in := ReadInputLines()
	p1 := Next(in[0])
	fmt.Printf("Part 1: %s\n", p1)
	fmt.Printf("Part 2: %s\n", Next(p1))
}
