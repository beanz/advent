package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type TransType byte

const (
	SwapPosition TransType = iota
	SwapLetter
	RotateLeft
	RotateRight
	RotateBase
	Reverse
	Move
)

type Transform struct {
	t    TransType
	arg1 byte
	arg2 byte
}

func NewTransform(s string) Transform {
	switch s[0] {
	case 's': // swap
		if s[5] == 'p' {
			// 0123456789112345678921234567893123456789
			// swap position D with position D
			return Transform{SwapPosition, s[14] - '0', s[30] - '0'}
		} else {
			// 0123456789112345678921234567893123456789
			// swap letter L with letter L
			return Transform{SwapLetter, s[12], s[26]}
		}
	case 'r': // rotate or reverse
		switch s[7] {
		case 'l':
			// 0123456789112345678921234567893123456789
			// rotate left D steps
			return Transform{RotateLeft, s[12] - '0', 0}
		case 'r':
			// 0123456789112345678921234567893123456789
			// rotate right D steps
			return Transform{RotateRight, s[13] - '0', 0}
		case 'b':
			// 0123456789112345678921234567893123456789
			// rotate based on position of letter L
			return Transform{RotateBase, s[35], 0}
		case ' ':
			// 0123456789112345678921234567893123456789
			// reverse positions D through D
			return Transform{Reverse, s[18] - '0', s[28] - '0'}
		}
	case 'm': // move
		// 0123456789112345678921234567893123456789
		// move position D to position D
		return Transform{Move, s[14] - '0', s[28] - '0'}
	}
	panic("")
}

func (t Transform) String() string {
	switch t.t {
	case SwapPosition:
		return fmt.Sprintf("swap pos %d %d", t.arg1, t.arg2)
	case SwapLetter:
		return fmt.Sprintf("swap letter %s %s", string(t.arg1), string(t.arg2))
	case RotateLeft:
		return fmt.Sprintf("rotate left %d", t.arg1)
	case RotateRight:
		return fmt.Sprintf("rotate right %d", t.arg1)
	case RotateBase:
		return fmt.Sprintf("rotate base %s", string(t.arg1))
	case Reverse:
		return fmt.Sprintf("reverse %d-%d", t.arg1, t.arg2)
	case Move:
		return fmt.Sprintf("move %d to %d", t.arg1, t.arg2)
	}
	panic("unknown transform type")
}

func (t Transform) ApplyTo(s string) string {
	switch t.t {
	case SwapPosition:
		return SwapLetters(s, rune(s[int(t.arg1)]), rune(s[int(t.arg2)]))
	case SwapLetter:
		return SwapLetters(s, rune(t.arg1), rune(t.arg2))
	case Reverse:
		return ReversePositions(s, int(t.arg1), int(t.arg2))
	case RotateLeft:
		return RotateSteps(s, int(t.arg1))
	case RotateRight:
		return RotateSteps(s, -1*int(t.arg1))
	case Move:
		return MovePositions(s, int(t.arg1), int(t.arg2))
	case RotateBase:
		i := strings.Index(s, string(t.arg1))
		dir := -1
		if i >= 4 {
			i++
		}
		i++
		return RotateSteps(s, i*dir)
	}
	panic("invalid transform type")
}

type Game struct {
	trans []Transform
	debug bool
}

func NewGame(lines []string) *Game {
	trans := make([]Transform, 0, len(lines))
	for _, l := range lines {
		trans = append(trans, NewTransform(l))
	}
	return &Game{trans, false}
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

func (g Game) Part1(in string) string {
	s := in
	for _, t := range g.trans {
		s = t.ApplyTo(s)
	}
	return s
}

func (g Game) Part2(in string) string {
	perms := Permutations(0, len(in)-1)
	for _, p := range perms {
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
	game := NewGame(InputLines(input))
	p1 := game.Part1("abcdefgh")
	if !benchmark {
		fmt.Printf("Part 1: %s\n", p1)
	}
	p2 := game.Part2("fbgdceah")
	if !benchmark {
		fmt.Printf("Part 2: %s\n", p2)
	}
}

var benchmark = false
