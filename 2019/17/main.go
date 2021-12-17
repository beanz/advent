package main

import (
	_ "embed"
	"fmt"
	"math"
	"strconv"
	"strings"

	"github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type SearchRecord struct {
	pos   Point
	steps int
	ic    *intcode.IntCode
}

type Search []SearchRecord

type Scaffold struct {
	m   map[Point]bool
	bb  *BoundingBox
	pos Point
	bot Point
	dir Direction
}

func NewScaffold() *Scaffold {
	return &Scaffold{make(map[Point]bool), NewBoundingBox(),
		Point{0, 0}, Point{-1, -1}, Direction{0, -1}}
}

func (s *Scaffold) String() string {
	str := ""
	for y := s.bb.Min.Y; y <= s.bb.Max.Y; y++ {
		for x := s.bb.Min.X; x <= s.bb.Max.X; x++ {
			if s.bot.X == x && s.bot.Y == y {
				str += "^"
			} else if s.IsPipe(Point{x, y}) {
				str += "#"
			} else {
				str += "."
			}
		}
		str += "\n"
	}
	return str
}

func (s *Scaffold) IsPipe(p Point) bool {
	v, ok := s.m[p]
	return ok && v
}

func (s *Scaffold) AlignmentSum() int {
	ans := 0
	for y := s.bb.Min.Y; y <= s.bb.Max.Y; y++ {
		for x := s.bb.Min.X; x <= s.bb.Max.X; x++ {
			if s.IsPipe(Point{x, y}) &&
				s.IsPipe(Point{x - 1, y}) &&
				s.IsPipe(Point{x, y - 1}) &&
				s.IsPipe(Point{x + 1, y}) &&
				s.IsPipe(Point{x, y + 1}) {
				ans += x * y
			}
		}
	}
	return ans
}

func part1(p []int64) *Scaffold {
	ic := intcode.NewIntCode(p, []int64{})
	output := ic.RunToHalt()
	scaff := NewScaffold()
	for _, ascii := range output {
		switch ascii {
		case 10:
			scaff.pos.X = 0
			scaff.pos.Y++
		case 35:
			scaff.m[scaff.pos] = true
			scaff.pos.X++
		case 94:
			scaff.m[scaff.pos] = true
			scaff.bot = Point{scaff.pos.X, scaff.pos.Y}
			scaff.pos.X++
		default:
			scaff.pos.X++
		}
		scaff.bb.Add(scaff.pos)
	}
	//fmt.Printf("%s\n", scaff)
	return scaff
}

func turnsFor(d Direction) []Direction {
	if d.Dx == 0 {
		if d.Dy == -1 {
			return []Direction{Direction{-1, 0}, Direction{1, 0}}
		}
		return []Direction{Direction{1, 0}, Direction{-1, 0}}
	} else if d.Dx == -1 {
		return []Direction{Direction{0, 1}, Direction{0, -1}}
	} else {
		return []Direction{Direction{0, -1}, Direction{0, 1}}
	}
}

func nextFunc(path string, off int, ch string) string {
	shortest := math.MaxInt64
	fun := ""
	for i := 1; i < 22; i++ {
		sub := path[off : off+i-1]
		t := strings.Replace(path, sub, ch, -1)
		if shortest > len(t) {
			shortest = len(t)
			fun = sub
		}
	}
	fun = strings.TrimRight(fun, ",RL")
	return fun
}

func part2(p []int64, scaff *Scaffold) int64 {
	pos := scaff.bot
	dir := scaff.dir
	path := []string{}
	for {
		np := pos.In(dir)
		if scaff.IsPipe(np) {
			//fmt.Printf("Move forward to %s\n", np)
			pos = np
			if len(path) > 0 {
				if steps, err := strconv.Atoi(path[len(path)-1]); err == nil {
					path[len(path)-1] = fmt.Sprintf("%d", steps+1)
				} else {
					path = append(path, "1")
				}
			} else {
				path = append(path, "1")
			}
		} else {
			turns := turnsFor(dir)
			np := pos.In(turns[0])
			if scaff.IsPipe(np) {
				//fmt.Printf("Turn left\n")
				dir = turns[0]
				path = append(path, "L")
			} else {
				np := pos.In(turns[1])
				if scaff.IsPipe(np) {
					//fmt.Printf("Turn right\n")
					dir = turns[1]
					path = append(path, "R")
				} else {
					break
				}
			}
		}
	}
	pathStr := strings.Join(path, ",")
	//fmt.Printf("Path: %s\n", pathStr)
	funA := nextFunc(pathStr, 0, "A")
	//fmt.Printf("A: %s\n", funA)
	pathStr = strings.Replace(pathStr, funA, "A", -1)
	off := 0
	for pathStr[off] == 'A' || pathStr[off] == ',' {
		off++
	}
	//fmt.Printf("Path after A: %s\n", pathStr)
	//fmt.Printf("Offset after A: %d\n", off)
	funB := nextFunc(pathStr, off, "B")
	//fmt.Printf("B: %s\n", funB)
	pathStr = strings.Replace(pathStr, funB, "B", -1)
	for pathStr[off] == 'A' || pathStr[off] == 'B' || pathStr[off] == ',' {
		off++
	}
	//fmt.Printf("Path after B: %s\n", pathStr)
	//fmt.Printf("Offset after B: %d\n", off)
	funC := nextFunc(pathStr, off, "C")
	//fmt.Printf("C: %s\n", funC)
	pathStr = strings.Replace(pathStr, funC, "C", -1)
	//fmt.Printf("Path after C: %s\n", pathStr)
	funM := pathStr

	inputStr := strings.Join([]string{funM, funA, funB, funC, "n\n"}, "\n")
	p[0] = 2
	ic := intcode.NewIntCodeFromASCII(p, inputStr)
	output := ic.RunToHalt()
	return output[len(output)-1]
}

func main() {
	p := FastInt64s(InputBytes(input), 4096)
	scaff := part1(p)
	p1 := scaff.AlignmentSum()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := part2(p, scaff)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
