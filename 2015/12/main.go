package main

import (
	"encoding/json"
	"fmt"
	"strings"

	. "github.com/beanz/advent2015/lib"
)

func Part1(s string) int {
	ints := Ints(s)
	return IntSum(ints)
}

func CountObj(o interface{}) int {
	switch v := o.(type) {
	case int:
		return v
	case float64:
		return int(v)
	case string:
		// here v has type S
		return 0
	case []interface{}:
		s := 0
		for _, e := range v {
			s += CountObj(e)
		}
		return s
	case map[string]interface{}:
		s := 0
		for _, e := range v {
			switch ev := e.(type) {
			case string:
				if ev == "red" {
					return 0
				}
			default:
				s += CountObj(ev)
			}
		}
		return s
	default:
		panic("Unsupported type: " + fmt.Sprintf("%q", o))
	}
	panic("Unreachable")
}

func Part2(s string) int {
	si := strings.Index(s, "{")
	if si == -1 {
		return IntSum(Ints(s))
	}
	var obj interface{}
	err := json.Unmarshal([]byte(s), &obj)
	if err != nil {
		panic("invalid json: " + err.Error())
	}
	return CountObj(obj)
}

func main() {
	in := ReadInputLines()
	fmt.Printf("Part 1: %d\n", Part1(in[0]))
	fmt.Printf("Part 2: %d\n", Part2(in[0]))
}
