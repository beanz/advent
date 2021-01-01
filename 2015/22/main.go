package main

import (
	"fmt"
	"math"

	. "github.com/beanz/advent2015/lib"
)

type Spell struct {
	name                                   string
	cost, damage, heal, armor, mana, turns int
}

var (
	MagicMissile = Spell{name: "Magic Missile", cost: 53, damage: 4}
	Drain        = Spell{name: "Drain", cost: 73, damage: 2, heal: 2}
	Shield       = Spell{name: "Shield", cost: 113, turns: 6, armor: 7}
	Poison       = Spell{name: "Poison", cost: 173, turns: 6, damage: 3}
	Recharge     = Spell{name: "Recharge", cost: 229, turns: 5, mana: 101}

	AllSpells = []Spell{MagicMissile, Drain, Shield, Poison, Recharge}
)

type ActiveSpells map[Spell]int

type Me struct {
	hp        int
	armor     int
	mana      int
	manaSpent int
	active    ActiveSpells
}

type Boss struct {
	hp, damage int
}

type Game struct {
	bossHp, bossDamage int
	part2              bool
	debug              bool
}

func NewGame(in []int) *Game {
	return &Game{
		bossHp:     in[0],
		bossDamage: in[1],
		debug:      false,
	}
}

type State struct {
	me   *Me
	boss *Boss
}

func (s *State) Clone() *State {
	nm := Me{hp: s.me.hp, armor: s.me.armor, mana: s.me.mana,
		manaSpent: s.me.manaSpent, active: make(map[Spell]int),
	}
	for k, v := range s.me.active {
		nm.active[k] = v
	}
	return &State{me: &nm, boss: &Boss{hp: s.boss.hp, damage: s.boss.damage}}
}

func (g *Game) Turn(state *State, sp Spell) *State {
	armor := 0
	if state.me.active[Shield] > 0 {
		if g.debug {
			fmt.Printf("Shield active increasing armor\n")
		}
		armor = 7
	}
	if g.debug {
		fmt.Printf("-- Player turn --\n")
		fmt.Printf("- Player has %d hit points, %d armor, %d mana\n",
			state.me.hp, armor, state.me.mana)
		fmt.Printf("- Boss has %d hit points\n", state.boss.hp)
	}
	for k := range state.me.active {
		state.me.hp += k.heal
		state.me.mana += k.mana
		state.boss.hp -= k.damage
		state.me.active[k]--
		if g.debug {
			fmt.Printf("%s active\n", k.name)
		}
		if state.me.active[k] == 0 {
			if g.debug {
				fmt.Printf("%s wears off\n", k.name)
			}
			delete(state.me.active, k)
		}
	}
	state.me.mana -= sp.cost
	state.me.manaSpent += sp.cost

	if sp.turns > 0 {
		if g.debug {
			fmt.Printf("Player casts %s\n", sp.name)
		}
		state.me.active[sp] = sp.turns
	} else {
		if g.debug {
			fmt.Printf("Player casts %s\n", sp.name)
		}
		state.me.hp += sp.heal
		state.me.mana += sp.mana
		state.boss.hp -= sp.damage
	}
	if g.debug && state.boss.hp <= 0 {
		fmt.Printf("Boss is dead\n")
		return state
	}

	if state.me.active[Shield] > 0 {
		if g.debug {
			fmt.Printf("Shield active increasing armor\n")
		}
		armor = 7
	}
	if g.debug {
		fmt.Printf("\n")
		fmt.Printf("-- Boss turn --\n")
		fmt.Printf("- Player has %d hit points, %d armor, %d mana\n",
			state.me.hp, armor, state.me.mana)
		fmt.Printf("- Boss has %d hit points\n", state.boss.hp)
	}
	for k := range state.me.active {
		state.me.hp += k.heal
		state.me.mana += k.mana
		state.boss.hp -= k.damage
		state.me.active[k]--
		if g.debug {
			fmt.Printf("%s active (%d)\n", k.name, state.me.active[k])
		}
		if state.me.active[k] == 0 {
			if g.debug {
				fmt.Printf("%s wears off\n", k.name)
			}
			delete(state.me.active, k)
		}
	}
	if g.debug && state.boss.hp <= 0 {
		fmt.Printf("Boss is dead\n")
		return state
	}
	damage := MaxInt(1, state.boss.damage-armor)
	if g.debug {
		fmt.Printf("Boss attacks for %d damage\n\n", damage)
	}
	state.me.hp -= damage
	if g.debug && state.me.hp <= 0 {
		fmt.Printf("Player is dead\n")
	}
	return state
}

func (g *Game) Calc() int {
	minCost := math.MaxInt32
	todo := []*State{&State{
		&Me{hp: 50, mana: 500, active: make(map[Spell]int)},
		&Boss{hp: g.bossHp, damage: g.bossDamage},
	}}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]

		for _, spell := range AllSpells {
			if cur.me.active[spell] > 1 {
				continue // currently active
			}
			if cur.me.mana < spell.cost {
				continue // can't afford spell
			}
			new := g.Turn(cur.Clone(), spell)
			if new.boss.hp <= 0 {
				if g.debug {
					fmt.Printf("Player wins %d (%d)\n",
						new.me.manaSpent, minCost)
				}
				if minCost > new.me.manaSpent {
					minCost = new.me.manaSpent
				}
				continue
			}
			if new.me.hp <= 0 {
				continue
			}
			todo = append(todo, new)
		}

	}
	return minCost
}

func (g *Game) Part1() int {
	return g.Calc()
}

func (g *Game) Part2() int {
	g.part2 = true
	return g.Calc()
}

func (g *Game) Trial1() {
	state := &State{
		&Me{hp: 10, mana: 250, active: make(map[Spell]int)},
		&Boss{hp: 13, damage: 8},
	}
	g.debug = true
	for _, sp := range []Spell{Poison, MagicMissile} {
		state = g.Turn(state, sp)
	}
	panic("Trial 1\n")
}

func (g *Game) Trial2() {
	state := &State{
		&Me{hp: 10, mana: 250, active: make(map[Spell]int)},
		&Boss{hp: 14, damage: 8},
	}
	g.debug = true
	for _, sp := range []Spell{Recharge, Shield, Drain, Poison, MagicMissile} {
		state = g.Turn(state, sp)
	}
	panic("Trial 2\n")
}

func main() {
	in := ReadInputInts()
	g := NewGame(in)
	fmt.Printf("Part 1: %d\n", g.Part1())
	fmt.Printf("Part 2: %d\n", g.Part2())
}

func MinInt(a int, b ...int) int {
	min := a
	for _, v := range b {
		if v < a {
			min = v
		}
	}
	return min
}

func MaxInt(a int, b ...int) int {
	max := a
	for _, v := range b {
		if v > a {
			max = v
		}
	}
	return max
}
