package main

import (
	_ "embed"
	"fmt"
	"log"
	"regexp"
	"strconv"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Op struct {
	code int
	A    int
	B    int
	C    int
}

type Chunk struct {
	before []int
	op     Op
	after  []int
}

type Game struct {
	output  []Chunk
	program []Op
}

func readInts(ints []string) ([]int, error) {
	nums := make([]int, 0, len(ints))

	for _, s := range ints {
		n, err := strconv.Atoi(s)
		if err != nil {
			return nil, err
		}
		nums = append(nums, n)
	}
	return nums, nil
}

func readGame(input string) *Game {
	parts := strings.Split(input, "\n\n\n\n")
	output := []Chunk{}
	for _, chunk := range strings.Split(parts[0], "\n\n") {
		chunkRe :=
			regexp.MustCompile(`Before: \[([^\]]+)\]\n(.*)\nAfter:  \[([^\]]+)\]`)
		m := chunkRe.FindStringSubmatch(chunk)
		if m == nil {
			log.Fatalf("invalid chunk:\n%s\n", chunk)
		}
		b, err := readInts(strings.Split(m[1], ", "))
		if err != nil {
			log.Fatalf("invalid first line of chunk:\n%s\n", chunk)
		}
		o, err := readInts(strings.Split(m[2], " "))
		if err != nil {
			log.Fatalf("invalid second line of chunk:\n%s\n", chunk)
		}
		a, err := readInts(strings.Split(m[3], ", "))
		if err != nil {
			log.Fatalf("invalid third line of chunk:\n%s\n", chunk)
		}
		output = append(output, Chunk{b, Op{o[0], o[1], o[2], o[3]}, a})
	}
	program := []Op{}
	lines := strings.Split(parts[1], "\n")
	for _, line := range lines[:len(lines)-1] {
		o, err := readInts(strings.Split(line, " "))
		if err != nil {
			log.Fatalf("invalid program line:\n  %s\n", line)
		}
		program = append(program, Op{o[0], o[1], o[2], o[3]})
	}
	//fmt.Printf("Output parsed %d output chunks\n", len(output))
	//fmt.Printf("Program parsed %d instructions\n", len(program))
	return &Game{output, program}
}

type Registers []int

func addr(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] + (*r)[b]
}
func addi(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] + b
}
func mulr(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] * (*r)[b]
}
func muli(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] * b
}
func banr(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] & (*r)[b]
}
func bani(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] & b
}
func borr(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] | (*r)[b]
}
func bori(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a] | b
}
func setr(r *Registers, a, b, c int) {
	(*r)[c] = (*r)[a]
}
func seti(r *Registers, a, b, c int) {
	(*r)[c] = a
}

func gtir(r *Registers, a, b, c int) {
	if a > (*r)[b] {
		(*r)[c] = 1
	} else {
		(*r)[c] = 0
	}
}
func gtri(r *Registers, a, b, c int) {
	if (*r)[a] > b {
		(*r)[c] = 1
	} else {
		(*r)[c] = 0
	}
}
func gtrr(r *Registers, a, b, c int) {
	if (*r)[a] > (*r)[b] {
		(*r)[c] = 1
	} else {
		(*r)[c] = 0
	}
}

func eqir(r *Registers, a, b, c int) {
	if a == (*r)[b] {
		(*r)[c] = 1
	} else {
		(*r)[c] = 0
	}
}
func eqri(r *Registers, a, b, c int) {
	if (*r)[a] == b {
		(*r)[c] = 1
	} else {
		(*r)[c] = 0
	}
}
func eqrr(r *Registers, a, b, c int) {
	if (*r)[a] == (*r)[b] {
		(*r)[c] = 1
	} else {
		(*r)[c] = 0
	}
}

type OpMap map[string]func(*Registers, int, int, int)

func OperatorMap() OpMap {
	return OpMap{
		"addr": addr,
		"addi": addi,
		"mulr": mulr,
		"muli": muli,
		"banr": banr,
		"bani": bani,
		"borr": borr,
		"bori": bori,
		"setr": setr,
		"seti": seti,
		"gtir": gtir,
		"gtri": gtri,
		"gtrr": gtrr,
		"eqir": eqir,
		"eqri": eqri,
		"eqrr": eqrr,
	}
}

func matches(c Chunk) []string {
	res := []string{}
	for name, fn := range OperatorMap() {
		r := Registers{c.before[0], c.before[1], c.before[2], c.before[3]}
		fn(&r, c.op.A, c.op.B, c.op.C)
		m := true
		for i := 0; i < 4; i++ {
			if r[i] != c.after[i] {
				m = false
				break
			}
		}
		if m {
			res = append(res, name)
		}
	}
	return res
}

func play1(g *Game) int {
	c := 0
	for _, chunk := range g.output {
		m := matches(chunk)
		if len(m) >= 3 {
			c++
		}
	}
	return c
}

func consistent(g *Game, code int, opName string) bool {
	fn := OperatorMap()[opName]
	for _, chunk := range g.output {
		if chunk.op.code != code {
			continue
		}
		r := Registers{chunk.before[0], chunk.before[1],
			chunk.before[2], chunk.before[3]}
		fn(&r, chunk.op.A, chunk.op.B, chunk.op.C)
		m := true
		for i := 0; i < 4; i++ {
			if r[i] != chunk.after[i] {
				m = false
				break
			}
		}
		if !m {
			return false
		}
	}
	return true
}

func addOpCode(o2c map[string]map[int]bool, name string, code int) {
	if _, ok := o2c[name]; !ok {
		o2c[name] = make(map[int]bool)
	}
	o2c[name][code] = true
}

func possibleOpCodes(o2c map[string]map[int]bool, name string) []int {
	codes := make([]int, 0, len(o2c[name]))
	for code := range o2c[name] {
		codes = append(codes, code)
	}
	return codes
}

func run(g *Game, opNames map[int]string) int {
	r := Registers{0, 0, 0, 0}
	for _, op := range g.program {
		fn := OperatorMap()[opNames[op.code]]
		fn(&r, op.A, op.B, op.C)
	}
	return r[0]
}

func play2(g *Game) int {
	op2code := make(map[string]map[int]bool)
	for opName := range OperatorMap() {
		for code := 0; code < 16; code++ {
			if consistent(g, code, opName) {
				addOpCode(op2code, opName, code)
			}
		}
	}
	//fmt.Printf("%v\n", op2code)
	solution := make(map[int]string)
	for len(solution) != 16 {
		for opName := range op2code {
			possibleCodes := possibleOpCodes(op2code, opName)
			if len(possibleCodes) == 1 {
				//fmt.Printf("found map %d => %s\n", possibleCodes[0], opName)
				solution[possibleCodes[0]] = opName
				delete(op2code, opName)
				for op := range op2code {
					delete(op2code[op], possibleCodes[0])
				}
			}
		}
	}
	s := ""
	for i := 0; i < 16; i++ {
		s += " " + solution[i]
	}
	//fmt.Printf("Part 1b:\n%s\n", s)
	return run(g, solution)
}

func main() {
	game := readGame(InputString(input))

	res := play1(game)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", res)
	}

	res = play2(game)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", res)
	}
}

var benchmark = false
