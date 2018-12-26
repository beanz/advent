package main

import (
	"crypto/md5"
	"fmt"
	"log"
	"os"
	"strings"
)

type Game struct {
	salt      string
	index     int
	md5cache  map[int]string
	stretched bool
	debug     bool
}

func (g *Game) String() string {
	return fmt.Sprintf("Salt: %s Index: %d\n", g.salt, g.index)
}

func (g *Game) MD5(i int) string {
	if s, ok := g.md5cache[i]; ok {
		return s
	}
	str := fmt.Sprintf("%s%d", g.salt, i)
	sum := fmt.Sprintf("%x", md5.Sum([]byte(str)))
	if g.stretched {
		for i := 0; i < 2016; i++ {
			sum = fmt.Sprintf("%x", md5.Sum([]byte(sum)))
		}
	}
	g.md5cache[i] = sum
	return sum
}

func Triple(s string) string {
	chars := []string{"0", "1", "2", "3", "4", "5", "6", "7", "8",
		"9", "a", "b", "c", "d", "e", "f"}
	best := 1000000
	res := ""
	for _, ch := range chars {
		triple := ch + ch + ch
		if i := strings.Index(s, triple); i != -1 {
			if i < best {
				res = ch
				best = i
			}
		}
	}
	return res
}

func (g *Game) NextKey() string {
	var sum string
LOOP:
	for {
		sum = g.MD5(g.index)
		delete(g.md5cache, g.index)
		g.index++
		ch := Triple(sum)
		if ch == "" {
			continue
		}
		match := ch + ch + ch + ch + ch
		for i := 0; i < 1000; i++ {
			sum = g.MD5(g.index + i)
			if strings.Contains(sum, match) {
				if g.debug {
					fmt.Printf("Got a hit at index %d\n", g.index-1)
				}
				break LOOP
			}
		}
	}
	return sum
}

func (g *Game) Play() int {
	for i := 0; i < 64; i++ {
		g.NextKey()
	}
	return g.index - 1
}

func main() {
	if len(os.Args) < 1 {
		log.Fatalf("Usage: %s <input>\n", os.Args[0])
	}
	input := os.Args[1]

	game := Game{input, 0, map[int]string{}, false, true}
	res := game.Play()
	fmt.Printf("Part 1: %d\n", res)

	game = Game{input, 0, map[int]string{}, true, true}
	res = game.Play()
	fmt.Printf("Part 2: %d\n", res)
}
