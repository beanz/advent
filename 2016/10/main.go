package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"

	. "github.com/beanz/advent-of-code-go"
)

type Output struct {
	num    int
	values []int
}

type Bot struct {
	*Output
	low  *Output
	high *Output
}

func (b *Bot) String() string {
	return fmt.Sprintf("Bot with values %v\n", b.values)
}

func (o *Output) String() string {
	return fmt.Sprintf("Output with values %v\n", o.values)
}

func (o *Output) AddValue(v int) {
	o.values = append(o.values, v)
}

type Game struct {
	bots    map[int]*Bot
	outputs map[int]*Output
	debug   bool
}

func (g *Game) Bot(i int) *Bot {
	if b, ok := g.bots[i]; ok {
		return b
	}
	if g.debug {
		fmt.Printf("Creating bot %d\n", i)
	}
	b := &Bot{&Output{i, []int{}}, nil, nil}
	g.bots[i] = b
	return b
}

func (g *Game) Output(i int) *Output {
	if o, ok := g.outputs[i]; ok {
		return o
	}
	if g.debug {
		fmt.Printf("Creating output %d\n", i)
	}
	o := &Output{i, []int{}}
	g.outputs[i] = o
	return o
}

func (g *Game) String() string {
	s := ""
	for k, v := range g.bots {
		s += fmt.Sprintf("Bot %d: %s\n", k, v)
	}
	for k, v := range g.outputs {
		s += fmt.Sprintf("Output %d: %s\n", k, v)
	}
	return s
}

func readGame(lines []string) *Game {
	game := Game{map[int]*Bot{}, map[int]*Output{}, false}
	for _, line := range lines {
		valueRe := regexp.MustCompile(`value (-?\d+) goes to bot (-?\d+)`)
		botRe := regexp.MustCompile(
			`bot (-?\d+) gives low to (bot|output) (-?\d+) and high to (bot|output) (-?\d+)`)
		m := botRe.FindStringSubmatch(line)
		if m == nil {
			m := valueRe.FindStringSubmatch(line)
			if m == nil {
				log.Fatalf("invalid line:\n%s\n", line)
			}
			value, err := strconv.Atoi(m[1])
			if err != nil {
				log.Fatalf("invalid value in line:\n%s\n", line)
			}
			botNum, err := strconv.Atoi(m[2])
			if err != nil {
				log.Fatalf("invalid bot in value line:\n%s\n", line)
			}
			if game.debug {
				fmt.Printf("value line: bot %d <= %d\n", botNum, value)
			}
			bot := game.Bot(botNum)
			bot.AddValue(value)
			continue
		}
		botNum, err := strconv.Atoi(m[1])
		if err != nil {
			log.Fatalf("invalid bot in bot line:\n%s\n", line)
		}
		lowType := m[2]
		highType := m[4]
		lowNum, err := strconv.Atoi(m[3])
		if err != nil {
			log.Fatalf("invalid low bot in line:\n%s\n", line)
		}
		highNum, err := strconv.Atoi(m[5])
		if err != nil {
			log.Fatalf("invalid high bot in line:\n%s\n", line)
		}
		if game.debug {
			fmt.Printf("bot line: %d => %d, %d\n", botNum, lowNum, highNum)
		}
		bot := game.Bot(botNum)
		if lowType == "bot" {
			bot.low = game.Bot(lowNum).Output
		} else {
			bot.low = game.Output(lowNum)
		}
		if highType == "bot" {
			bot.high = game.Bot(highNum).Output
		} else {
			bot.high = game.Output(highNum)
		}
	}
	return &game
}

func (g *Game) Part1() int {
	for {
		for i, bot := range g.bots {
			if len(bot.values) != 2 {
				continue
			}
			var min, max int
			if bot.values[0] > bot.values[1] {
				min = bot.values[1]
			} else {
				min = bot.values[0]
			}
			if bot.values[0] > bot.values[1] {
				max = bot.values[0]
			} else {
				max = bot.values[1]
			}
			if min == 17 && max == 61 {
				return i
			}
			if g.debug {
				fmt.Printf("adding %d to bot %d\n", min, bot.low.num)
			}
			bot.low.AddValue(min)
			if g.debug {
				fmt.Printf("adding %d to bot %d\n", max, bot.high.num)
			}
			bot.high.AddValue(max)
			bot.values = []int{}
		}
	}
}

func (g *Game) Part2() int {
	for {
		for _, bot := range g.bots {
			if len(bot.values) != 2 {
				continue
			}
			var min, max int
			if bot.values[0] > bot.values[1] {
				min = bot.values[1]
			} else {
				min = bot.values[0]
			}
			if bot.values[0] > bot.values[1] {
				max = bot.values[0]
			} else {
				max = bot.values[1]
			}
			if g.debug {
				fmt.Printf("adding %d to bot %d\n", min, bot.low.num)
			}
			bot.low.AddValue(min)
			if g.debug {
				fmt.Printf("adding %d to bot %d\n", max, bot.high.num)
			}
			bot.high.AddValue(max)
			bot.values = []int{}
		}
		if len(g.outputs[0].values) > 0 &&
			len(g.outputs[1].values) > 0 &&
			len(g.outputs[2].values) > 0 {
			return g.outputs[0].values[0] * g.outputs[1].values[0] *
				g.outputs[2].values[0]
		}
	}
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game := readGame(ReadLines(input))

	//fmt.Printf("%s\n", game)
	res := game.Part1()
	fmt.Printf("Part 1: %d\n", res)
	//fmt.Printf("%s\n", game)

	res = game.Part2()
	fmt.Printf("Part 2: %d\n", res)
	//fmt.Printf("%s\n", game)
}
