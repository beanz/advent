package main

import (
	"crypto/md5"
	"fmt"

	. "github.com/beanz/advent2015/lib"
)

type NumStr struct {
	b  []byte
	l  int
	pl int
}

func NewNumStr(prefix string) *NumStr {
	pl := len(prefix)
	b := make([]byte, pl+10)
	copy(b, []byte(prefix))
	b[len(prefix)] = '0'
	return &NumStr{b: b, l: pl + 1, pl: pl}
}

func (n *NumStr) Bytes() []byte {
	return n.b[:n.l]
}

func (n *NumStr) String() string {
	return string(n.b[:n.l])
}

func (n *NumStr) Inc() {
	for i := n.l - 1; i >= n.pl; i-- {
		n.b[i]++
		if n.b[i] <= '9' {
			return
		}
		n.b[i] = '0'
	}
	n.b[n.pl] = '1'
	n.b[n.l] = '0'
	n.l++
}

func calc(secret string) (int, int) {
	var p1 int
	n := NewNumStr(secret)
	for i := 1; ; i++ {
		n.Inc()
		cs := md5.Sum(n.Bytes())
		if cs[0] == 0 && cs[1] == 0 && cs[2]&0xf0 == 0 {
			if p1 == 0 {
				p1 = i
			}
			if cs[2] == 0 {
				return p1, i
			}
		}
	}
	return 0, 0
}

func main() {
	s := ReadInputLines()
	p1, p2 := calc(s[0])
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
