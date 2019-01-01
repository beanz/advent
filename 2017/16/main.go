package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	. "github.com/beanz/advent-of-code-go"
)

type Dance struct {
	programs string
	moves    []string
	debug    bool
}

func ReadDance(programs string, s string) *Dance {
	return &Dance{programs, strings.Split(s, ","), false}
}

func (d *Dance) Spin(x int) {
	offset := len(d.programs) - x
	n := d.programs[offset:] + d.programs[:offset]
	d.programs = n
}

func (d *Dance) Exchange(a, b int) {
	n := ""
	for i := 0; i < len(d.programs); i++ {
		switch {
		case i == a:
			n += string(d.programs[b])
		case i == b:
			n += string(d.programs[a])
		default:
			n += string(d.programs[i])
		}
	}
	d.programs = n
}

func (d *Dance) Partner(a, b byte) {
	n := ""
	for i := 0; i < len(d.programs); i++ {
		switch {
		case d.programs[i] == a:
			n += string(b)
		case d.programs[i] == b:
			n += string(a)
		default:
			n += string(d.programs[i])
		}
	}
	d.programs = n
}

func (d *Dance) Part1() string {
	for _, m := range d.moves {
		switch m[0] {
		case 's':
			n, err := strconv.Atoi(m[1:])
			if err != nil {
				log.Fatalf("Invalid spin size in %s: %s\n", m, err)
			}
			d.Spin(n)
		case 'x':
			args := SimpleReadInts(m[1:])
			d.Exchange(args[0], args[1])
		case 'p':
			d.Partner(m[1], m[3])
		default:
			log.Fatalf("Invalid move %s\n", m)
		}
	}
	return d.programs
}

func (d *Dance) Part2() string {
	start := time.Now()
	seen := map[string]int{}
	end := 10000000
	cycleFound := false
	for c := 1; c <= end; c++ {
		if (c % 1000) == 0 {
			now := time.Now()
			elapsed := now.Sub(start)
			fmt.Fprintf(os.Stderr, "%d %s\r", c, elapsed)
			start = now
		}
		d.Part1()
		if !cycleFound && seen[d.programs] != 0 {
			if d.debug {
				fmt.Printf("Found cycle %s at %d and %d\n",
					d.programs, seen[d.programs], c)
			}
			remaining := end - c
			cycleLen := c - seen[d.programs]
			c += (remaining / cycleLen) * cycleLen
			cycleFound = true
		}
		seen[d.programs] = c
	}
	return d.programs
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	dance := ReadDance("abcdefghijklmnop", ReadLines(os.Args[1])[0])
	fmt.Printf("Part 1: %s\n", dance.Part1())
	dance = ReadDance("abcdefghijklmnop", ReadLines(os.Args[1])[0])
	fmt.Printf("Part 2: %s\n", dance.Part2())
}
