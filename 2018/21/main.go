package main

import (
	"fmt"
	"log"
	"os"

	. "github.com/beanz/advent/lib-go"
)

func Part1(e *ElfProg2018) int {
	found := -1
	e.Run(func(e *ElfProg2018) bool {
		if e.IP == 28 {
			found = e.Reg[5]
			return true
		}
		return false
	})
	return found
}

func Part2Slow(e *ElfProg2018) int {
	seen := map[int]bool{}
	prev := -1
	e.Run(func(e *ElfProg2018) bool {
		if e.IP == 28 {
			v := e.Reg[5]
			if seen[v] {
				return true
			}
			seen[v] = true
			prev = v
		}
		return false
	})
	return prev
}

func Part2(e *ElfProg2018) int {
	prev := -1
	seen := map[int]bool{}
	R := [6]int{}
	/* seti 123 0 5 */
	R[5] = 123
L1:
	/* bani 5 456 5 */
	R[5] &= 456
	/* eqri 5 72 5 */
	if R[5] == 72 {
		R[5] = 1
	} else {
		R[5] = 0
	}
	/* IP! addr 5 4 4 */
	if R[5] == 1 {
		goto L5
	}
	/* IP! seti 0 0 4 */
	goto L1
L5:
	/* seti 0 6 5 */
	R[5] = 0
L6:
	/* bori 5 65536 1 */
	R[1] = R[5] | 65536
	/* seti 4591209 6 5 */
	R[5] = 4591209
L8:
	/* bani 1 255 3 */
	R[3] = R[1] & 255
	/* addr 5 3 5 */
	R[5] = R[5] + R[3]
	/* bani 5 16777215 5 */
	R[5] = R[5] & 16777215
	/* muli 5 65899 5 */
	R[5] = R[5] * 65899
	/* bani 5 16777215 5 */
	R[5] = R[5] & 16777215
	/* gtir 256 1 3 */
	if 256 > R[1] {
		R[3] = 1
	} else {
		R[3] = 0
	}
	/* IP! addr 3 4 4 */
	if R[3] == 1 {
		goto L16
	}
	/* IP! addi 4 1 4 */
	goto L17
L16:
	/* IP! seti 27 7 4 */
	goto L28
L17:
	/* seti 0 0 3 */
	R[3] = 0
L18:
	/* addi 3 1 2 */
	R[2] = R[3] + 1
	/* muli 2 256 2 */
	R[2] = R[2] * 256
	/* gtrr 2 1 2 */
	if R[2] > R[1] {
		R[2] = 1
	} else {
		R[2] = 0
	}
	/* IP! addr 2 4 4 */
	if R[2] == 1 {
		goto L23
	}
	/* IP! addi 4 1 4 */
	goto L24
L23:
	/* IP! seti 25 4 4 */
	goto L26
L24:
	/* addi 3 1 3 */
	R[3] = R[3] + 1
	/* IP! seti 17 0 4 */
	goto L18
L26:
	/* setr 3 4 1 */
	R[1] = R[3]
	/* IP! seti 7 2 4 */
	goto L8
L28:
	if seen[R[5]] {
		return prev
	}
	seen[R[5]] = true
	prev = R[5]
	/* eqrr 5 0 3 */
	if R[5] == R[0] {
		R[3] = 1
	} else {
		R[3] = 0
	}
	R[4] = 28
	/* IP! addr 3 4 4 */
	if R[3] == 1 {
		goto L31
	}
	/* IP! seti 5 1 4 */
	goto L6
L31:
	fmt.Printf("R[0] = %d\n", R[0])
	return -1
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	e := NewElfProg2018(ReadLines(os.Args[1]))
	fmt.Printf("Part 1: %d\n", Part1(e))
	fmt.Printf("Part 2: %d\n", Part2(nil))
}
