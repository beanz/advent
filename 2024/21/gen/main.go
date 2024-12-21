package main

import (
	"bytes"
	_ "embed"
	"fmt"
	"os"

	keypads "github.com/beanz/advent/2024/21/pkg"
)

func main() {
	var b bytes.Buffer
	fmt.Fprintf(&b, "package main\n\n// generated with go run gen/main.go\n\n")
	fmt.Fprintf(&b, "var (\n")
	for i, d := range []int{2, 25} {
		chunks := 10 / (1 + i)
		fmt.Fprintf(&b, "\tdepth%d = []int{\n", d)
		for n := 0; n < 1000; n++ {
			v := keypads.MoveLen(fmt.Sprintf("%03dA", n), d)
			switch n % chunks {
			case 0:
				fmt.Fprintf(&b, "\t\t%d, ", v)
			case chunks - 1:
				fmt.Fprintf(&b, "%d,\n", v)
			default:
				fmt.Fprintf(&b, "%d, ", v)
			}
		}
		fmt.Fprintf(&b, "\t}\n")
	}
	fmt.Fprintf(&b, ")\n")
	err := os.WriteFile("vars.go", b.Bytes(), 0600)
	if err != nil {
		panic(err)
	}
}
