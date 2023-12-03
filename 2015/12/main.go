package main

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Part1(in []byte) int {
	p1 := 0
	n := 0
	m := 1
	num := false
	for _, ch := range in {
		if '0' <= ch && ch <= '9' {
			n = n*10 + int(ch-'0')
			num = true
		} else {
			if num {
				p1 += m * n
				n = 0
				m = 1
				num = false
			}
		}
		if ch == '-' {
			m = -1
		}
	}
	return p1
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
}

func Part2(s string) int {
	si := strings.Index(s, "{")
	if si == -1 {
		return Sum(Ints(s)...)
	}
	var obj interface{}
	err := json.Unmarshal([]byte(s), &obj)
	if err != nil {
		panic("invalid json: " + err.Error())
	}
	return CountObj(obj)
}

func main() {
	in := InputLines(input)
	p1 := Part1(input)
	p2 := Part2(in[0])
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark bool
