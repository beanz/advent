package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	. "github.com/beanz/advent-of-code-go"
)

type Field struct {
	min1, max1, min2, max2 int
}

type Ticket []int

type Mess struct {
	fields     map[string]Field
	our        Ticket
	tickets    []Ticket
	error      int
	onlyDepart bool
	debug      bool
}

func NewMess(lines []string) *Mess {
	fields := make(map[string]Field)
	i := 0
	for ; i < len(lines); i++ {
		if len(lines[i]) == 0 {
			break
		}
		s := strings.Split(lines[i], ": ")
		ints := SimpleReadInts(strings.ReplaceAll(s[1], "-", " "))
		fields[s[0]] = Field{
			min1: ints[0], max1: ints[1],
			min2: ints[2], max2: ints[3],
		}
	}
	i += 2
	our := SimpleReadInts(lines[i])
	if DEBUG() {
		fmt.Printf("our: %v\n", our)
	}

	i += 3
	tickets := []Ticket{our}
	error := 0
	for ; i < len(lines); i++ {
		ticket := SimpleReadInts(lines[i])
		validTicket := true
		for _, v := range ticket {
			validField := false
			for _, field := range fields {
				if (v >= field.min1 && v <= field.max1) ||
					(v >= field.min2 && v <= field.max2) {
					validField = true
					break
				}
			}
			if !validField {
				validTicket = false
				error += v
			}
		}
		if validTicket {
			tickets = append(tickets, ticket)
		}
	}
	if DEBUG() {
		fmt.Printf("num valid: %d\n", len(tickets))
	}
	return &Mess{fields, our, tickets, error, true, false}
}

func (m *Mess) Solve() int {

	possible := make(map[string]map[int]bool) // field name => [columns]
	for name := range m.fields {
		possible[name] = make(map[int]bool)
	}
	target := len(m.tickets)
	for col := 0; col < len(m.our); col++ {
		for name, field := range m.fields {
			valid := 0
			for _, ticket := range m.tickets {
				val := ticket[col]
				if (val >= field.min1 && val <= field.max1) ||
					(val >= field.min2 && val <= field.max2) {
					valid++
				}
			}
			if valid == target {
				if DEBUG() {
					fmt.Printf("found %s at %d (%d)\n",
						name, col, m.our[col])
				}
				possible[name][col] = true
			}
		}
	}

	p := 1

	for {
		progress := false
		for name, cols := range possible {
			if len(cols) == 1 {
				progress = true
				var col int
				for k := range cols {
					col = k
				}
				if DEBUG() {
					fmt.Printf("Definite %s is %d (%d)\n",
						name, col, m.our[col])
				}
				delete(possible, name)
				for n := range possible {
					delete(possible[n], col)
				}
				if strings.HasPrefix(name, "departure") || !m.onlyDepart {
					p *= m.our[col]
					if DEBUG() {
						fmt.Printf("product: %d\n", p)
					}
				}
				if len(possible) == 0 {
					return p
				}
			}
		}
		if !progress {
			panic("Unable to solve")
		}
	}
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	m := NewMess(lines)
	fmt.Printf("Part 1: %d\n", m.error)
	if os.Args[1] == "test2.txt" {
		m.onlyDepart = false
	}
	fmt.Printf("Part 2: %d\n", m.Solve())
}
