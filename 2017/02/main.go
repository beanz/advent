package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"os"
	"strconv"
	"strings"
)

type Game struct {
	l [][]int
}

func readInts(lines []string) ([]int, error) {
	nums := make([]int, 0, len(lines))

	for _, line := range lines {
		n, err := strconv.Atoi(line)
		if err != nil {
			return nil, err
		}
		nums = append(nums, n)
	}
	return nums, nil
}

func readInput(file string) *Game {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("Failed to read input %s", err)
	}
	lines := strings.Split(string(b), "\n")
	g := &Game{[][]int{}}
	for i, l := range lines[:len(lines)-1] {
		nums, err := readInts(strings.Split(l, "\t"))
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
	game := readInput(input)

	res := game.Part1()
	fmt.Printf("Part 1: %d\n", res)

	res = game.Part2()
	fmt.Printf("Part 2: %d\n", res)
}
