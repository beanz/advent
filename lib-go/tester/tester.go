package tester

import (
	"bytes"
	"fmt"
	"os"
	"testing"

	. "github.com/beanz/advent/lib-go"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func RunWithArgs(t *testing.T, fn func([]byte, ...int) (int, int)) {
	d, err := os.ReadFile("TC.txt")
	require.NoError(t, err)
	for _, chunk := range bytes.Split(d, []byte("\n---END---\n")) {
		s := bytes.Split(chunk, []byte("\n"))
		t.Run(string(s[0]), func(t *testing.T) {
			args := bytes.Split(s[0], []byte(" "))
			f := args[0]
			args = args[1:]
			_, p1 := ChompInt[int](s[1], 0)
			_, p2 := ChompInt[int](s[2], 0)
			fd, err := os.ReadFile(string(f))
			require.NoError(t, err)
			var argsInt []int
			for _, v := range args {
				_, x := ChompInt[int](v, 0)
				argsInt = append(argsInt, x)
			}
			a1, a2 := fn(fd, argsInt...)
			assert.Equal(t, p1, a1, "part 1")
			assert.Equal(t, p2, a2, "part 2")
		})
	}
}

func Run(t *testing.T, fn func([]byte) (int, int)) {
	d, err := os.ReadFile("TC.txt")
	require.NoError(t, err)
	for _, chunk := range bytes.Split(d, []byte("\n---END---\n")) {
		s := bytes.Split(chunk, []byte("\n"))
		t.Run(string(s[0]), func(t *testing.T) {
			_, p1 := ChompInt[int](s[1], 0)
			_, p2 := ChompInt[int](s[2], 0)
			fd, err := os.ReadFile(string(s[0]))
			require.NoError(t, err)
			a1, a2 := fn(fd)
			assert.Equal(t, p1, a1, "part 1")
			assert.Equal(t, p2, a2, "part 2")
		})
	}
}

func RunAnyWithArgs[T any,U any](t *testing.T, fn func([]byte, ...int) (T, U)) {
	d, err := os.ReadFile("TC.txt")
	require.NoError(t, err)
	for _, chunk := range bytes.Split(d, []byte("\n---END---\n")) {
		s := bytes.Split(chunk, []byte("\n"))
		t.Run(string(s[0]), func(t *testing.T) {
			args := bytes.Split(s[0], []byte(" "))
			f := args[0]
			args = args[1:]
			fd, err := os.ReadFile(string(f))
			require.NoError(t, err)
			var argsInt []int
			for _, v := range args {
				_, x := ChompInt[int](v, 0)
				argsInt = append(argsInt, x)
			}
			a1, a2 := fn(fd, argsInt...)
			assert.Equal(t, string(s[1]), fmt.Sprintf("%v", a1), "part 1")
			assert.Equal(t, string(s[2]), fmt.Sprintf("%v", a2), "part 2")
		})
	}
}


func RunAny[T any,U any](t *testing.T, fn func([]byte) (T, U)) {
	d, err := os.ReadFile("TC.txt")
	require.NoError(t, err)
	for _, chunk := range bytes.Split(d, []byte("\n---END---\n")) {
		s := bytes.Split(chunk, []byte("\n"))
		t.Run(string(s[0]), func(t *testing.T) {
			fd, err := os.ReadFile(string(s[0]))
			require.NoError(t, err)
			a1, a2 := fn(fd)
			assert.Equal(t, s[1], fmt.Sprintf("%v", a1), "part 1")
			assert.Equal(t, s[2], fmt.Sprintf("%v", a2), "part 2")
		})
	}
}
