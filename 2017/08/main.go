package main

import (
	_ "embed"
	"fmt"
	"math"
	"log"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type CPU struct {
	prog  []string
	reg   map[string]int
	max   int
	debug bool
}

func NewCPU(inp []string) *CPU {
	return &CPU{inp, map[string]int{}, math.MinInt64, false}
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
	p1 := NewCPU(InputLines(input)).Part1()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := NewCPU(InputLines(input)).Part2()
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
