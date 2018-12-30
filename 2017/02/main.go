package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Game struct {
	l [][]int
}

func readGame(lines []string) *Game {
	g := &Game{[][]int{}}
	for i, l := range lines {
		nums, err := ReadInts(strings.Split(l, "\t"))
		if err != nil {
			log.Fatalf("Invalid int in line %d: %s\n", i, err)
		}
		g.l = append(g.l, nums)
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
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game := readGame(ReadLines(input))

	res := game.Part1()
	fmt.Printf("Part 1: %d\n", res)

	res = game.Part2()
	fmt.Printf("Part 2: %d\n", res)
}
