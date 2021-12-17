package main

import (
	_ "embed"
	"fmt"
	"math/rand"
	"strings"

	"github.com/mxschmitt/golang-combinations"

	"github.com/beanz/advent/lib-go/intcode"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func part1(prog []int64) int {
	ic := intcode.NewIntCode(prog, []int64{})
	inv := []string{}
	bad := make(map[string]bool, 5)
	for _, b := range []string{"giant electromagnet", "infinite loop",
		"photons", "escape pod", "molten lava"} {
		bad[b] = true
	}
	combos := [][]string{}
	lastDir := ""
	for {
		s := ""
		rc := ic.Run()
		if rc == intcode.NeedInput || rc == intcode.Finished {
			for {
				out := ic.Out(1)
				if len(out) != 1 {
					break
				}
				s += string(rune(out[0]))
			}
			//fmt.Print(s)
			if strings.Contains(s, "Analysis complete") {
				//fmt.Print(s)
				ints := SimpleReadInts(s)
				return ints[0]
			}
			if len(combos) > 0 {
				//fmt.Print(s)
				combo := combos[0]
				combos = combos[1:]
				//fmt.Printf("Trying combo %v\n", combo)
				for _, item := range inv {
					ic.InStr("drop " + item + "\n")
				}
				for _, item := range combo {
					ic.InStr("take " + item + "\n")
				}
				// ic.InStr("inv\n")
				ic.InStr(lastDir + "\n")
				continue
			}
			if strings.Contains(s, "eject") {
				//fmt.Printf("Found exit\n")
				if len(inv) == 8 {
					//fmt.Printf("Have all items!\n")
					combos = combinations.All(inv)
					continue
				} else {
					//fmt.Printf("Need more items (%v)!\n", inv)
				}
			}
			ii := strings.Index(s, "Items")
			if ii != -1 {
				ii += 12
				for {
					if s[ii] != '-' {
						break
					}
					ii += 2
					eol := strings.Index(s[ii:], "\n")
					item := s[ii : ii+eol]
					ii += eol
					if _, ok := bad[item]; !ok {
						ic.InStr("take " + item + "\n")
						//fmt.Printf("picked up %s\n", item)
						inv = append(inv, item)
					} else {
						//fmt.Printf("Ignoring %s\n", item)
					}
				}
			}
			dirIndex := strings.LastIndex(s, "Doors here lead")
			if dirIndex == -1 {
				continue
			}
			dirStr := s[dirIndex:]
			dir := []string{}
			for _, d := range []string{"north", "south", "east", "west"} {
				if strings.Contains(dirStr, d) {
					dir = append(dir, d)
				}
			}
			n := rand.Int() % len(dir)
			lastDir = dir[n]
			//fmt.Printf("Sending '%s'\n", lastDir)
			ic.InStr(lastDir + "\n")
			s = ""
		}
	}
	return -1
}

func main() {
	prog := FastInt64s(InputBytes(input), 4096)
	p1 := part1(prog)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
}

var benchmark = false
