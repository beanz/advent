package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type block struct {
	size, id, idx int
}

func defrag(file []block, free []block) int {
	s := 0
	firstFree := []int{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	for i := len(file) - 1; i >= 0; i-- {
		if file[i].id == -1 || file[i].size <= 0 {
			continue
		}

		for j := firstFree[file[i].size]; j < len(free) && file[i].idx > free[j].idx; j++ {
			if file[i].size > free[j].size {
				continue
			}
			firstFree[file[i].size] = j
			file[i].idx = free[j].idx
			free[j].idx += file[i].size
			free[j].size -= file[i].size
			break
		}
		for k := 0; k < file[i].size; k++ {
			s += (file[i].idx + k) * file[i].id
		}
	}
	return s
}

func Parts(in []byte, args ...int) (int, int) {
	file1 := make([]block, 0, 65536)
	free1 := make([]block, 0, 65536)
	file2 := make([]block, 0, 10240)
	free2 := make([]block, 0, 10240)
	i := 0
	for j, ch := range in[:len(in)-1] {
		size := int(ch - '0')
		var id int
		if j%2 == 0 {
			id = j / 2
			file2 = append(file2, block{size: size, id: id, idx: i})
			for k := 0; k < size; k++ {
				file1 = append(file1, block{size: 1, id: id, idx: i})
				i++
			}
		} else {
			free2 = append(free2, block{size: size, id: -1, idx: i})
			for k := 0; k < size; k++ {
				free1 = append(free1, block{size: 1, id: -1, idx: i})
				i++
			}
		}
	}
	//fmt.Fprintf(os.Stderr, "%d/%d %d/%d\n", len(file1), len(free1), len(file2), len(free2))
	return defrag(file1, free1), defrag(file2, free2)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
