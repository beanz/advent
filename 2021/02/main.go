package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed "input.txt"
var input []byte

func Move(in []byte) (int, int) {
	p1, p2 := Point{X: 0, Y: 0}, Point3D{X: 0, Y: 0, Z: 0} // Z=aim
	for i := 0; i < len(in); {
		switch in[i] {
		case 'f':
			u := int(in[i+8] - '0')
			p1.X += u
			p2.X += u
			p2.Y += p2.Z * u
			i += 10
		case 'd':
			u := int(in[i+5] - '0')
			p1.Y += u
			p2.Z += u
			i += 7
		case 'u':
			u := int(in[i+3] - '0')
			p1.Y -= u
			p2.Z -= u
			i += 5
		default:
			panic("parse error")
		}
	}
	return p1.X * p1.Y, p2.X * p2.Y
}

func main() {
	p1, p2 := Move(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
