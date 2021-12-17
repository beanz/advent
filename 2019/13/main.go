package main

import (
	_ "embed"
	"fmt"

	"github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func run(p []int64, input func() int64, reader func(int64, int64, int64)) {
	ic := intcode.NewIntCode(p, []int64{})
	for {
		rc := ic.Run()
		if rc == intcode.ProducedOutput {
			o := ic.Out(3)
			if len(o) >= 3 {
				reader(o[0], o[1], o[2])
				o = o[3:]
			}
			continue
		} else if rc == intcode.NeedInput {
			ic.In(input())
			continue
		}
		break
	}
	return
}

func part1(p []int64) int {
	blocks := 0
	run(p,
		func() int64 {
			return 0
		},
		func(x, y, t int64) {
			if t == 2 {
				blocks++
			}
		})
	return blocks
}

func part2(p []int64) int64 {
	var paddle, ball, score int64
	p[0] = 2
	// fmt.Fprintf(os.Stderr, "\033[3K\033[H\033[2J") // clear
	run(p,
		func() int64 {
			if ball < paddle {
				return -1
			} else if ball > paddle {
				return 1
			}
			return 0
		},
		func(x, y, t int64) {
			if x == -1 && y == 0 {
				score = t
				return
			} else if t == 3 {
				paddle = x
			} else if t == 4 {
				ball = x
			}
			// fmt.Fprintf(os.Stderr,
			// 	"\033[%d;%dH%s", y+1, x+1,
			// 	[]string{" ", "#", "=", "-", "o"}[t])
			// time.Sleep(2 * time.Millisecond)
		})
	return score
}

func main() {
	p := FastInt64s(InputBytes(input), 4096)
	p1 := part1(p)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p = FastInt64s(InputBytes(input), 4096)
	p2 := part2(p)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
