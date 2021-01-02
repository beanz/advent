package main

import (
	"fmt"
	"math"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

type Fighter struct {
	hp, damage, armor int
}

type Who bool

const (
	Player Who = true
	Enemy  Who = false
)

type Battle struct {
	player Fighter
	enemy  Fighter
}

func Attack(damage, armor int) int {
	return MaxInt(1, damage-armor)
}

func TimeToDeath(hp, damage, armor int) int {
	return int(math.Ceil(float64(hp) / float64(Attack(damage, armor))))
}

func (b Battle) Victory() Who {
	if TimeToDeath(b.enemy.hp, b.player.damage, b.enemy.armor) <=
		TimeToDeath(b.player.hp, b.enemy.damage, b.player.armor) {
		return Player
	}
	return Enemy
}

type Item struct {
	name                string
	cost, damage, armor int
}

type Shop struct {
	weapons []Item
	armor   []Item
	rings   []Item
}

func ParseItems(in string) []Item {
	items := []Item{}
	lines := strings.Split(strings.TrimRight(in, "\n"), "\n")
	for _, l := range lines[1:] {
		name := strings.TrimRight(l[:12], " ")
		ints := Ints(l[12:])
		items = append(items,
			Item{name: name, cost: ints[0], damage: ints[1], armor: ints[2]})
	}
	return items
}

func TotalStats(items ...Item) Item {
	t := Item{}
	n := []string{}
	for _, item := range items {
		n = append(n, item.name)
		t.cost += item.cost
		t.damage += item.damage
		t.armor += item.armor
	}
	t.name = strings.Join(n, ", ")
	return t
}

func NewShop(in []string) *Shop {
	shop := Shop{ParseItems(in[0]), ParseItems(in[1]), ParseItems(in[2])}
	shop.armor = append(shop.armor, Item{name: "None"})
	shop.rings = append(shop.rings, Item{name: "None"}, Item{name: "None"})
	return &shop
}

type Game struct {
	enemy Fighter
	shop  *Shop
}

func NewGame(in []int) *Game {
	return &Game{
		enemy: Fighter{hp: in[0], damage: in[1], armor: in[2]},
		shop:  NewShop(ReadFileChunks("shop.txt")),
	}
}

func (g *Game) Calc() (int, int) {
	min := math.MaxInt32
	max := math.MinInt32

	shop := g.shop
	for wi := 0; wi < len(shop.weapons); wi++ {
		for ai := 0; ai < len(shop.armor); ai++ {
			for r1 := 0; r1 < len(shop.rings); r1++ {
				for r2 := r1 + 1; r2 < len(shop.rings); r2++ {
					// we test some ring combinations too many times but it
					// keeps code simple
					me := Fighter{hp: 100}
					total := TotalStats(
						shop.weapons[wi], shop.armor[ai],
						shop.rings[r1], shop.rings[r2])
					me.damage = total.damage
					me.armor = total.armor
					battle := Battle{player: me, enemy: g.enemy}
					if battle.Victory() == Player && total.cost < min {
						min = total.cost
					}
					if battle.Victory() == Enemy && total.cost > max {
						max = total.cost
					}
				}
			}
		}
	}
	return min, max
}

func (g *Game) Part1() int {
	min, _ := g.Calc()
	return min
}

func (g *Game) Part2() int {
	_, max := g.Calc()
	return max
}

func main() {
	in := ReadInputInts()
	g := NewGame(in)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}
