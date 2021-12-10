package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func playMarbles(players, marbles int) int {
	maxScore := 0
	scores := make([]int, players)
	circle := []int{0}

	for m := 1; m <= marbles; m++ {
		if m%23 == 0 {
			player := (m - 1) % players
			scores[player] += m
			for i := 0; i < 7; i++ {
				circle = append([]int{circle[len(circle)-1]}, circle[:len(circle)-1]...)
			}
			scores[player] += circle[0]
			circle = circle[1:]
			if scores[player] > maxScore {
				maxScore = scores[player]
			}
		} else {
			circle = append(circle[1:], circle[0])
			circle = append(circle[1:], circle[0])
			circle = append([]int{m}, circle...)
		}
		//fmt.Println(circle)
	}
	return maxScore
}

type circleElement struct {
	m   int
	cw  *circleElement
	ccw *circleElement
}

func playMarblesFaster(players, marbles int) int {
	maxScore := 0
	scores := make([]int, players)
	circle := &circleElement{0, nil, nil}
	circle.cw = circle
	circle.ccw = circle

	for m := 1; m <= marbles; m++ {
		if m%23 == 0 {
			player := (m - 1) % players
			scores[player] += m
			for i := 0; i < 7; i++ {
				circle = circle.ccw
			}
			removed := circle
			removed.ccw.cw = removed.cw
			removed.cw.ccw = removed.ccw
			circle = removed.cw
			scores[player] += removed.m
			if scores[player] > maxScore {
				maxScore = scores[player]
			}
		} else {
			newElement := &circleElement{m, circle.cw.cw, circle.cw}
			newElement.ccw.cw = newElement
			newElement.cw.ccw = newElement
			circle = newElement
		}
	}
	return maxScore
}

func main() {
	ints := SimpleReadInts(InputLines(input)[0])
	players, marbles := ints[0], ints[1]
	p1 := playMarblesFaster(players, marbles)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := playMarblesFaster(players, marbles*100)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
