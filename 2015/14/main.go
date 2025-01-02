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

type Deer struct {
	name     string
	speed    int
	flyTime  int
	restTime int
	cTime    int
	flying   bool
	dist     int
	score    int
}

func Calc(in []string, endTime int) (int, int) {
	deer := []*Deer{}
	for _, l := range in {
		ints := Ints(l)
		deer = append(deer,
			&Deer{
				name:     strings.Split(l, " ")[0],
				speed:    ints[0],
				flyTime:  ints[1],
				restTime: ints[2],
				cTime:    ints[1],
				flying:   true,
				dist:     0,
				score:    0,
			})
	}
	t := 0
	maxDist := math.MinInt32
	maxScore := math.MinInt32
	maxi := make(map[int]bool)
	for ; t < endTime; t++ {
		for i, d := range deer {
			if d.flying {
				d.dist += d.speed
				if d.dist > maxDist {
					maxDist = d.dist
					maxi = make(map[int]bool)
					maxi[i] = true
				} else if d.dist == maxDist {
					maxi[i] = true
				}
			}
			d.cTime--
			if d.cTime == 0 {
				if d.flying {
					d.cTime = d.restTime
					d.flying = false
				} else {
					d.cTime = d.flyTime
					d.flying = true
				}
			}
		}
		for j := range maxi {
			deer[j].score++
			if deer[j].score > maxScore {
				maxScore = deer[j].score
			}
		}
	}
	return maxDist, maxScore
}

func Part1(in []string, endTime int) int {
	p1, _ := Calc(in, endTime)
	return p1
}

func Part2(in []string, endTime int) int {
	_, p2 := Calc(in, endTime)
	return p2
}

func main() {
	file := InputFile()
	in := InputLines(input)
	endTime := 2503
	if file == "test1.txt" {
		endTime = 1000
	}
	p1 := Part1(in, endTime)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(in, endTime)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
