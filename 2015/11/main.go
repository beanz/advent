package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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
	pw := NewPerlyString(cur)
	pw.Inc()
	for ; !Valid(pw.String()); pw.Inc() {
	}
	return pw.String()
}

func main() {
	in := InputLines(input)
	p1 := Next(in[0])
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	p2 := Next(p1)
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark bool
