package main

import (
	_ "embed"
	"fmt"
	"math"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Game struct {
	l [][]int
}

func readGame(lines []string) *Game {
	g := &Game{[][]int{}}
	for _, l := range lines {
		g.l = append(g.l, ReadInts(strings.Split(l, "\t")))
	}
	return g
}

func MinMax(nums []int) (int, int) {
	min := math.MaxInt64
	max := math.MinInt64
	for _, n := range nums {
		if n < min {
			min = n
		}
		if n > max {
			max = n
		}
	}
	return min, max
}

func DivisibleResult(nums []int) int {
	for i := 0; i < len(nums); i++ {
		for j := i + 1; j < len(nums); j++ {
			if nums[i]%nums[j] == 0 {
				return nums[i] / nums[j]
			}
			if nums[j]%nums[i] == 0 {
				return nums[j] / nums[i]
			}
		}
	}
	return 0
}

func (g *Game) Part1() int {
	sum := 0
	for _, l := range g.l {
		min, max := MinMax(l)
		sum += max - min
	}
	return sum
}

func (g *Game) Part2() int {
	sum := 0
	for _, l := range g.l {
		sum += DivisibleResult(l)
	}
	return sum
}

func main() {
	game := readGame(InputLines(input))

	res := game.Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", res)
	}

	res = game.Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", res)
	}
}

var benchmark = false
