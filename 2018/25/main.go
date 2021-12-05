package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"math"
	//"regexp"
	//"sort"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Star struct {
	x, y, z, t int
}

func (s Star) String() string {
	return fmt.Sprintf("[%d,%d,%d,%d]", s.x, s.y, s.z, s.t)
}

func (s Star) ManhattanDistance(other Star) int {
	return int(math.Abs(float64(s.x)-float64(other.x)) +
		math.Abs(float64(s.y)-float64(other.y)) +
		math.Abs(float64(s.z)-float64(other.z)) +
		math.Abs(float64(s.t)-float64(other.t)))
}

type Constellation []Star

func (c Constellation) String() string {
	r := []string{}
	for _, s := range c {
		r = append(r, s.String())
	}
	return strings.Join(r, " ")
}

func (c Constellation) InConstellation(s Star) bool {
	for _, ss := range c {
		if s.ManhattanDistance(ss) <= 3 {
			return true
		}
	}
	return false
}

type Game struct {
	stars          []Star
	constellations map[int]Constellation
	debug          bool
}

func (g *Game) String() string {
	r := ""
	for i, c := range g.constellations {
		r += fmt.Sprintf("%d: %s\n", i, c)
	}
	return r
}

func readInput(file string) (*Game, error) {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		return nil, err
	}
	return readGame(string(b)), nil
}

func readInts(intStrings []string) ([]int, error) {
	nums := make([]int, 0, len(intStrings))

	for _, intString := range intStrings {
		n, err := strconv.Atoi(intString)
		if err != nil {
			return nil, err
		}
		nums = append(nums, n)
	}
	return nums, nil
}

func readGame(input string) *Game {
	lines := strings.Split(input, "\n")
	stars := []Star{}
	for _, line := range lines[:len(lines)-1] {
		ints, err := readInts(strings.Split(line, ","))
		if err != nil {
			log.Fatalf("error parsing ints '%s': %s\n", line, err)
		}
		stars = append(stars, Star{ints[0], ints[1], ints[2], ints[3]})
	}
	constellations := make(map[int]Constellation)
	return &Game{stars, constellations, false}
}

func (g *Game) Part1() int {
	for k, s := range g.stars {
		possibleKeys := []int{}
		// highest first to make removal not corrupt indices
		for i, c := range g.constellations {
			if c.InConstellation(s) {
				possibleKeys = append(possibleKeys, i)
			}
		}
		if len(possibleKeys) == 0 {
			g.constellations[k] = Constellation{s}
		} else {
			g.constellations[possibleKeys[0]] =
				append(g.constellations[possibleKeys[0]], s)
			for i := 1; i < len(possibleKeys); i++ {
				//fmt.Printf("Combining constellation %d with %d\n",
				//	possibleKeys[0], possibleKeys[i])
				g.constellations[possibleKeys[0]] =
					append(g.constellations[possibleKeys[0]],
						g.constellations[possibleKeys[i]]...)
				delete(g.constellations, possibleKeys[i])
			}
		}
	}
	return len(g.constellations)
}

func main() {
	game, err := readInput(InputFile())
	if err != nil {
		log.Fatalf("error reading input: %s\n", err)
	}

	res := game.Part1()
	fmt.Printf("Part 1: %d\n", res)
}
