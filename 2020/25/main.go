package main

import (
	_ "embed"
	"fmt"
	"math/big"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func LoopSize(pub uint64) int64 {
	ls := int64(0)
	for p := uint64(1); p != pub; ls++ {
		p *= 7
		p %= 20201227
	}
	return ls
}

func Part1(in []string) string {
	cardLS := LoopSize(MustParseUint64(in[0]))
	doorPub, _ := new(big.Int).SetString(in[1], 10)
	m := big.NewInt(20201227)
	var res big.Int
	res.Exp(doorPub, big.NewInt(cardLS), m)
	return res.String()
}

func main() {
	lines := InputLines(input)
	p1 := Part1(lines)
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
}

var benchmark = false
