package main

import (
	"fmt"
	"math/big"

	. "github.com/beanz/advent/lib-go"
)

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
	lines := ReadInputLines()
	fmt.Printf("Part 1: %s\n", Part1(lines))
}
