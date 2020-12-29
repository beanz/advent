package main

import (
	"fmt"

	. "github.com/beanz/advent2015/lib"
)

func sw(s string, fn func(int, int, string)) {
	ints := Ints(s)
	sw := "toggle"
	if s[1] == 'u' {
		if s[6] == 'n' {
			sw = "on"
		} else {
			sw = "off"
		}
	}
	for x := ints[0]; x <= ints[2]; x++ {
		for y := ints[1]; y <= ints[3]; y++ {
			fn(x, y, sw)
		}
	}
}

func calc(in []string) (int, int) {
	var l1 [1000 * 1000]bool
	var l2 [1000 * 1000]int
	for _, inst := range in {
		sw(inst, func(x, y int, s string) {
			i := x + 1000*y
			switch s {
			case "off":
				l1[i] = false
				l2[i]--
				if l2[i] < 0 {
					l2[i] = 0
				}
			case "on":
				l1[i] = true
				l2[i]++
			default: // toggle
				l1[i] = !l1[i]
				l2[i] += 2
			}
		})
	}
	c1 := 0
	c2 := 0
	for i := range l2 {
		if l1[i] {
			c1++
		}
		c2 += l2[i]
	}
	return c1, c2
}

func main() {
	in := ReadInputLines()
	p1, p2 := calc(in)
	fmt.Printf("Part 1: %d\n", p1)
	fmt.Printf("Part 2: %d\n", p2)
}
