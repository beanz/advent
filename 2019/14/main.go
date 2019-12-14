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

type Chemical string

type Input struct {
	ch  Chemical
	num int
}

type Reaction struct {
	num    int
	inputs []Input
}

type Reactions map[Chemical]Reaction

type Quantities struct {
	surplus int
	total   int
}

type Production map[Chemical]*Quantities

type Factory struct {
	reactions Reactions
	prod      Production
	debug     bool
}

func (f *Factory) String() string {
	s := fmt.Sprintf("%d", len(f.reactions))
	return s
}

func (f *Factory) Reset() {
	f.prod = make(Production, len(f.reactions))
}

func NewFactory(lines []string) *Factory {
	reactions := make(Reactions, len(lines))
	for _, line := range lines {
		s := strings.Split(line, " => ")
		outStrings := strings.Split(s[1], " ")
		outName := outStrings[1]
		outNum, err := strconv.Atoi(outStrings[0])
		if err != nil {
			panic("Invalid output number")
		}
		inputs := []Input{}
		for _, in := range strings.Split(s[0], ", ") {
			inStrings := strings.Split(in, " ")
			inName := inStrings[1]
			inNum, err := strconv.Atoi(inStrings[0])
			if err != nil {
				panic("Invalid input number")
			}
			inputs = append(inputs, Input{Chemical(inName), inNum})
		}
		reactions[Chemical(outName)] = Reaction{outNum, inputs}
	}
	return &Factory{reactions, make(Production, len(reactions)), false}
}

func CeilDiv(a, b int) int {
	return int(math.Ceil(float64(a) / float64(b)))
}

func (f *Factory) Surplus(ch Chemical) int {
	if _, ok := f.prod[ch]; ok {
		return f.prod[ch].surplus
	}
	return 0
}

func (f *Factory) UseSurplus(ch Chemical, num int) int {
	if _, ok := f.prod[ch]; !ok {
		f.prod[ch] = &Quantities{0, 0}
	}
	if f.prod[ch].surplus < num {
		panic(fmt.Sprintf("no surplus of %s (%d < %d)",
			ch, f.prod[ch].surplus, num))
	}
	f.prod[ch].surplus -= num
	return f.prod[ch].surplus
}

func (f *Factory) Produce(ch Chemical, num int) {
	if _, ok := f.prod[ch]; !ok {
		f.prod[ch] = &Quantities{0, 0}
	}
	f.prod[ch].total += num
}

func (f *Factory) Requirements(ch Chemical, needed int) {
	if ch == "ORE" {
		return
	}
	r := f.reactions[ch]
	surplusAvail := f.Surplus(ch)
	if surplusAvail > needed {
		f.UseSurplus(ch, needed)
		return
	}
	if surplusAvail > 0 {
		needed -= surplusAvail
		f.UseSurplus(ch, surplusAvail)
	}
	required := CeilDiv(needed, r.num)
	surplus := r.num*required - needed
	f.UseSurplus(ch, -surplus) // *cough*
	for _, in := range r.inputs {
		f.Produce(in.ch, in.num*required)
		f.Requirements(in.ch, in.num*required)
	}
}

func (f *Factory) OreFor(num int) int {
	fuel := Chemical("FUEL")
	ore := Chemical("ORE")
	f.Requirements(fuel, num)
	return f.prod[ore].total
}

func (f *Factory) Part1() int {
	return f.OreFor(1)
}

func (f *Factory) Part2() int {
	target := 1000000000000
	upper := 1
	for {
		f.Reset()
		ore := f.OreFor(upper)
		if ore >= target {
			break
		}
		upper *= 2
	}
	lower := upper / 2
	for {
		mid := lower + (upper-lower)/2
		if mid == lower {
			break
		}
		f.Reset()
		ore := f.OreFor(mid)
		if ore > target {
			upper = mid
		} else {
			lower = mid
		}
	}
	return lower
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", NewFactory(lines).Part1())
	fmt.Printf("Part 2: %d\n", NewFactory(lines).Part2())
}
