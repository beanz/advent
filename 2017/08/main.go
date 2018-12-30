package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type CPU struct {
	prog  []string
	reg   map[string]int
	max   int
	debug bool
}

func NewCPU(file string) *CPU {
	return &CPU{ReadLines(file), map[string]int{}, math.MinInt64, false}
}

func (c *CPU) Run() {
	for _, l := range c.prog {
		inst := strings.Split(l, " ")
		if inst[3] != "if" {
			log.Fatalf("Invalid instruction: %s\n", l)
		}
		val, err := strconv.Atoi(inst[2])
		if err != nil {
			log.Fatalf("Invalid value in %s: %s\n", l, err)
		}
		testVal, err := strconv.Atoi(inst[6])
		if err != nil {
			log.Fatalf("Invalid test value in %s: %s\n", l, err)
		}
		if inst[1] == "dec" {
			val *= -1
		}
		var iffy bool
		switch inst[5] {
		case ">":
			iffy = c.reg[inst[4]] > testVal
		case "<":
			iffy = c.reg[inst[4]] < testVal
		case ">=":
			iffy = c.reg[inst[4]] >= testVal
		case "<=":
			iffy = c.reg[inst[4]] <= testVal
		case "==":
			iffy = c.reg[inst[4]] == testVal
		case "!=":
			iffy = c.reg[inst[4]] != testVal
		default:
			log.Fatalf("Invalid test: %s\n", l)
		}
		if iffy {
			c.reg[inst[0]] += val
			if c.reg[inst[0]] > c.max {
				c.max = c.reg[inst[0]]
			}
		}
	}
}

func (c *CPU) Part1() int {
	c.Run()
	max := math.MinInt64
	for _, v := range c.reg {
		if v > max {
			max = v
		}
	}
	return max
}

func (c *CPU) Part2() int {
	c.Run()
	return c.max
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	fmt.Printf("Part 1: %d\n", NewCPU(os.Args[1]).Part1())
	fmt.Printf("Part 2: %d\n", NewCPU(os.Args[1]).Part2())
}
