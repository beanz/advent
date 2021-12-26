package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Digits(s []uint8, n int) string {
	str := ""
	for i := 0; i < n; i++ {
		str += string(rune(s[i] + 48))
	}
	return str
}

func Part1(inp []uint8, phases int) string {
	REP := []int{0, 1, 0, -1}
	s := inp
	o := make([]uint8, 0, 650)
	//fmt.Printf("Input signal: %s\n", Digits(s, 8))
	for ph := 1; ph <= phases; ph++ {
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
			o = append(o, uint8(n))
			//fmt.Printf("\n")
		}
		s, o = o, s[:0]
		//fmt.Printf("Phase %d: %s\n", ph, Digits(s, 8))
	}
	return Digits(s, 8)
}

func Offset(s []uint8, digits int) int {
	r := 0
	for i := 0; i < digits; i++ {
		r *= 10
		r += int(s[i])
	}
	return r
}

func Part2(inp []uint8) string {
	off := Offset(inp, 7)
	inp10000 := make([]uint8, 0, 521801)
	k := 0
	for i := 0; i < 10000; i++ {
		for j := 0; j < len(inp); j++ {
			if k >= off {
				inp10000 = append(inp10000, inp[j])
			}
			k++
		}
	}
	//fmt.Printf("Input signal: %s\n", Digits(s, 8))
	phases := 100
	o := make([]uint8, 0, 521801)
	for ph := 1; ph <= phases; ph++ {
		sum := 0
		for i := 0; i < len(inp10000); i++ {
			sum += int(inp10000[i])
		}
		for i := 0; i < len(inp10000); i++ {
			n := sum
			if n < 0 {
				n *= -1
			}
			n = n % 10
			o = append(o, uint8(n))
			sum -= int(inp10000[i])
		}
		inp10000, o = o, inp10000[:0]
		//fmt.Printf("Phase %d: %s\n", ph, Digits(inp10000, 8))
	}
	return Digits(inp10000, 8)
}

func ReadUint8s(in []byte) []uint8 {
	inp := make([]uint8, 0, len(in))
	for i := 0; i < len(in); i++ {
		inp = append(inp, uint8(in[i])-48)
	}
	return inp
}

func main() {
	inp := InputBytes(input)
	p1 := Part1(ReadUint8s(inp[:len(inp)-1]), 100)
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	inp = InputBytes(input)
	p2 := Part2(ReadUint8s(inp[:len(inp)-1]))
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
