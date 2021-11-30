package main

import (
	"fmt"
	"log"
	"math"
	"math/big"
	"os"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

func Part1(lines []string) int {
	dt, err := strconv.Atoi(lines[0])
	if err != nil {
		log.Fatalf("invalid departure time %s\n", lines[0])
	}
	min := math.MaxInt32
	minBus := -1
	for _, ts := range strings.Split(lines[1], ",") {
		if ts == "x" {
			continue
		}
		t, err := strconv.Atoi(ts)
		//fmt.Printf("%d\n", t)
		if err != nil {
			log.Fatalf("invalid bus time %s\n", ts)
		}
		mt := t - (dt % t)
		//fmt.Printf("%d\n", mt)
		if mt < min {
			min = mt
			minBus = t
		}
	}
	return min * minBus
}

var one = big.NewInt(1)

func crt(a, n []*big.Int) *big.Int {
	p := new(big.Int).Set(n[0])
	for _, n1 := range n[1:] {
		p.Mul(p, n1)
	}
	var x, q, s, z big.Int
	for i, n1 := range n {
		q.Div(p, n1)
		z.GCD(nil, &s, n1, &q)
		if z.Cmp(one) != 0 {
			log.Fatalf("%d not coprime\n", n1)
		}
		x.Add(&x, s.Mul(a[i], s.Mul(&s, &q)))
		x.Mod(&x, p)
	}
	return &x
}

func Part2(lines []string) *big.Int {
	buses := strings.Split(lines[1], ",")
	a := []*big.Int{}
	n := []*big.Int{}
	for i, ts := range buses {
		if ts == "x" {
			continue
		}
		t, err := strconv.Atoi(ts)
		if err != nil {
			log.Fatalf("invalid bus time %s\n", ts)
		}
		a = append(a, big.NewInt(int64(t-i)))
		n = append(n, big.NewInt(int64(t)))
	}
	return crt(a, n)
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", Part1(lines))
	fmt.Printf("Part 2: %d\n", Part2(lines))
}
