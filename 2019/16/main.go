package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Calc1(s []uint) []uint {
	REP := []int{0, 1, 0, -1}
	o := []uint{}
	for i := 1; i <= len(s); i++ {
		n := 0
		for j := 0; j < len(s); j++ {
			di := (1 + j) / i
			m := REP[di%4]
			d := int(s[j]) * m
			n += d
			//fmt.Printf("%d*%d(%d) + ", s[j], m, d)
		}
		if n < 0 {
			n *= -1
		}
		n = n % 10
		o = append(o, uint(n))
		//fmt.Printf("\n")
	}
	return o
}

func Digits(s []uint, n int) string {
	str := ""
	for i := 0; i < n; i++ {
		str += string(rune(s[i] + 48))
	}
	return str
}

func Part1(inp []uint, phases int) string {
	s := inp
	//fmt.Printf("Input signal: %s\n", Digits(s, 8))
	for ph := 1; ph <= phases; ph++ {
		s = Calc1(s)
		//fmt.Printf("Phase %d: %s\n", ph, Digits(s, 8))
	}
	return Digits(s, 8)
}

func Offset(s []uint, digits int) int {
	r := 0
	for i := 0; i < digits; i++ {
		r *= 10
		r += int(s[i])
	}
	return r
}
func Calc2(s []uint) []uint {
	o := []uint{}
	sum := 0
	for i := 0; i < len(s); i++ {
		sum += int(s[i])
	}
	for i := 0; i < len(s); i++ {
		n := sum
		if n < 0 {
			n *= -1
		}
		n = n % 10
		o = append(o, uint(n))
		sum -= int(s[i])
	}
	return o
}

func Part2(inp []uint) string {
	off := Offset(inp, 7)
	inp10000 := []uint{}
	o := 0
	for i := 0; i < 10000; i++ {
		for j := 0; j < len(inp); j++ {
			if o >= off {
				inp10000 = append(inp10000, inp[j])
			}
			o++
		}
	}
	//fmt.Printf("Input signal: %s\n", Digits(s, 8))
	phases := 100
	for ph := 1; ph <= phases; ph++ {
		inp10000 = Calc2(inp10000)
		//fmt.Printf("Phase %d: %s\n", ph, Digits(inp10000, 8))
	}
	return Digits(inp10000, 8)
}

func ReadUint8s(line string) []uint {
	inp := []uint{}
	for i := 0; i < len(line); i++ {
		inp = append(inp, uint(line[i])-48)
	}
	return inp
}

func main() {
	lines := InputLines(input)
	inp := ReadUint8s(lines[0])
	p1 := Part1(inp, 100)
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	p2 := Part2(inp)
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
