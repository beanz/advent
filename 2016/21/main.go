package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Game struct {
	lines []string
	debug bool
}

func readGame(lines []string) *Game {
	return &Game{lines, false}
}

func SwapLetters(s string, a, b rune) string {
	s = strings.Replace(s, string(a), "@", -1)
	s = strings.Replace(s, string(b), string(a), -1)
	s = strings.Replace(s, "@", string(b), -1)
	return s
}

func MovePositions(s string, i, j int) string {
	n := ""
	for k := 0; k < len(s); k++ {
		if k == i {
			continue
		}
		if k == j && i > j {
			n += string(s[i])
		}
		n += string(s[k])
		if k == j && i < j {
			n += string(s[i])
		}
	}
	return n
}

func ReversePositions(s string, i, j int) string {
	n := ""
	for k := 0; k < i; k++ {
		n += string(s[k])
	}
	for k := j; k >= i; k-- {
		n += string(s[k])
	}
	for k := j + 1; k < len(s); k++ {
		n += string(s[k])
	}
	return n
}

func RotateSteps(s string, o int) string {
	n := ""
	for j := 0; j < len(s); j++ {
		i := (2*len(s) + j + o) % len(s)
		n += string(s[i])
	}
	return n
}

func (g *Game) ApplyTransform(s, transform string) string {
	swapPosRe := regexp.MustCompile(`swap position (\d+) with position (\d+)`)
	swapLetterRe := regexp.MustCompile(`swap letter (.) with letter (.)`)
	rotateStepsRe := regexp.MustCompile(`rotate (left|right) (\d+) steps?`)
	rotateBaseRe := regexp.MustCompile(`rotate based on position of letter (.)`)
	reverseRe := regexp.MustCompile(`reverse positions (\d+) through (\d+)`)
	moveRe := regexp.MustCompile(`move position (\d+) to position (\d+)`)
	if g.debug {
		fmt.Printf("S: %s\nL: %s\n", s, transform)
	}
	m := swapPosRe.FindStringSubmatch(transform)
	if m != nil {
		i, err := strconv.Atoi(m[1])
		if err != nil {
			log.Fatalf("swap first position invalid: %s", err)
		}
		j, err := strconv.Atoi(m[2])
		if err != nil {
			log.Fatalf("swap second position invalid: %s", err)
		}
		s = SwapLetters(s, rune(s[i]), rune(s[j]))
		return s
	}
	m = swapLetterRe.FindStringSubmatch(transform)
	if m != nil {
		s = SwapLetters(s, rune(m[1][0]), rune(m[2][0]))
		return s
	}
	m = reverseRe.FindStringSubmatch(transform)
	if m != nil {
		i, err := strconv.Atoi(m[1])
		if err != nil {
			log.Fatalf("reverse first position invalid: %s", err)
		}
		j, err := strconv.Atoi(m[2])
		if err != nil {
			log.Fatalf("reverse second position invalid: %s", err)
		}
		s = ReversePositions(s, i, j)
		return s
	}
	m = rotateStepsRe.FindStringSubmatch(transform)
	if m != nil {
		var dir int
		if m[1] == "left" {
			dir = 1
		} else {
			dir = -1
		}
		i, err := strconv.Atoi(m[2])
		if err != nil {
			log.Fatalf("rotate steps invalid: %s", err)
		}
		s = RotateSteps(s, i*dir)
		return s
	}
	m = moveRe.FindStringSubmatch(transform)
	if m != nil {
		i, err := strconv.Atoi(m[1])
		if err != nil {
			log.Fatalf("move first position invalid: %s", err)
		}
		j, err := strconv.Atoi(m[2])
		if err != nil {
			log.Fatalf("move second position invalid: %s", err)
		}
		s = MovePositions(s, i, j)
		return s
	}
	m = rotateBaseRe.FindStringSubmatch(transform)
	if m != nil {
		i := strings.Index(s, m[1])
		dir := -1
		if i >= 4 {
			i++
		}
		i++
		s = RotateSteps(s, i*dir)
		return s
	}
	return s
}

func (g Game) Part1(in string) string {
	s := in
	for _, l := range g.lines {
		s = g.ApplyTransform(s, l)
	}
	return s
}

func (g Game) Part2(in string) string {
	perms := Permutations(0, len(in)-1)
	for pn, p := range perms {
		fmt.Fprintf(os.Stderr, "%6.2f\r", 100*(float64(pn)/float64(len(perms))))
		s := ""
		for _, i := range p {
			s += string(in[i])
		}
		if g.Part1(s) == in {
			return s
		}
	}
	return "oops"
}

func main() {
	game := readGame(ReadInputLines())
	fmt.Printf("Part 1: %s\n", game.Part1("abcdefgh"))
	fmt.Printf("Part 2: %s\n", game.Part2("fbgdceah"))
}
