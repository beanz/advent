package main

import (
	"fmt"
	"strconv"
	"strings"

	aoc "github.com/beanz/advent/lib-go"
)

type Inst struct {
	op  string
	arg int
}

func (i Inst) String() string {
	return fmt.Sprintf("%s %d", i.op, i.arg)
}

type HH struct {
	code  []Inst
	ip    int
	acc   int
	debug bool
}

func NewHH(lines []string) *HH {
	hh := &HH{[]Inst{}, 0, 0, false}
	for _, l := range lines {
		sp := strings.Split(l, " ")
		n, err := strconv.Atoi(sp[1])
		if err != nil {
			panic(err)
		}
		hh.code = append(hh.code, Inst{sp[0], n})
	}
	return hh
}

func (hh *HH) Clone() *HH {
	code := make([]Inst, len(hh.code))
	copy(code, hh.code)
	return &HH{code, 0, 0, false}
}

func (hh *HH) Reset() {
	hh.ip, hh.acc = 0, 0
}

func (hh *HH) Run() {
	seen := make(map[int]bool, len(hh.code))
	for hh.ip < len(hh.code) {
		if _, ok := seen[hh.ip]; ok {
			break
		}
		seen[hh.ip] = true
		inst := hh.code[hh.ip]
		if hh.debug {
			fmt.Printf("%d %d %s\n", hh.ip, hh.acc, inst)
		}
		hh.ip++
		switch inst.op {
		case "acc":
			hh.acc += inst.arg
		case "jmp":
			hh.ip += inst.arg - 1
		}
	}
}

func (hh *HH) Part1() int {
	hh.Run()
	return hh.acc
}

func (hh *HH) Part2() int {
	for i := range hh.code {
		mhh := hh.Clone()
		if mhh.code[i].op == "jmp" {
			mhh.code[i].op = "nop"
		} else if mhh.code[i].op == "nop" {
			mhh.code[i].op = "jmp"
		} else {
			continue
		}
		mhh.Run()
		if mhh.ip == len(hh.code) {
			return mhh.acc
		}
	}
	return 0
}

func main() {
	lines := aoc.ReadInputLines()
	hh := NewHH(lines)
	fmt.Printf("Part 1: %d\n", hh.Part1())
	fmt.Printf("Part 2: %d\n", hh.Part2())
}
