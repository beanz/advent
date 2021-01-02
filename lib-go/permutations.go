package aoc

import (
	"math/bits"
)

func Permutations(min, max int) [][]int {
	orig := []int{}
	for i := min; i <= max; i++ {
		orig = append(orig, i)
	}
	var helper func([]int, int)
	res := [][]int{}

	helper = func(orig []int, n int) {
		if n == 1 {
			tmp := make([]int, len(orig))
			copy(tmp, orig)
			res = append(res, tmp)
		} else {
			for i := 0; i < n; i++ {
				helper(orig, n-1)
				if n%2 == 1 {
					tmp := orig[i]
					orig[i] = orig[n-1]
					orig[n-1] = tmp
				} else {
					tmp := orig[0]
					orig[0] = orig[n-1]
					orig[n-1] = tmp
				}
			}
		}
	}
	helper(orig, len(orig))
	return res
}

type Perms struct {
	orig []int
	perm []int
}

func NewPerms(n int) *Perms {
	p := &Perms{orig: make([]int, n), perm: make([]int, n)}
	for i := 0; i < n; i++ {
		p.orig[i] = i
	}
	return p
}

func (p *Perms) Done() bool {
	return p.perm[0] == len(p.perm)-1
}

func (p *Perms) Next() []int {
	for i := len(p.perm) - 1; i >= 0; i-- {
		if i == 0 || p.perm[i] < len(p.perm)-i-1 {
			p.perm[i]++
			break
		}
		p.perm[i] = 0
	}
	return p.Get()
}

func (p *Perms) Get() []int {
	result := append([]int{}, p.orig...)
	for i, v := range p.perm {
		result[i], result[i+v] = result[i+v], result[i]
	}
	return result
}

func Variations(k, n int) [][]int {
	if k == 1 {
		return [][]int{[]int{n}}
	}
	res := [][]int{}
	for i := 0; i <= n; i++ {
		sr := Variations(k-1, n-i)
		for _, e := range sr {
			r := make([]int, len(e)+1)
			r[0] = i
			copy(r[1:], e)
			res = append(res, r)
		}
	}
	return res
}

type Subsets struct {
	i    int
	imax int
	n    int
}

func NewSubsets(n int) *Subsets {
	return &Subsets{1, (1 << n), n}
}

func (ss *Subsets) Done() bool {
	return ss.i == ss.imax
}

func (ss *Subsets) Next() []int {
	ss.i++
	return ss.Get()
}

func (ss *Subsets) Get() []int {
	var subset []int
	for i := 0; i < ss.n; i++ {
		if (ss.i>>i)&1 == 1 {
			subset = append(subset, i)
		}
	}
	return subset
}

type Combs struct {
	i    int
	imax int
	n    int
	k    int
}

func NewCombs(n int, k int) *Combs {
	num := 1
	for bits.OnesCount(uint(num)) != k {
		num++
	}
	return &Combs{num, (1 << n), n, k}
}

func (c *Combs) Done() bool {
	return c.i >= c.imax
}

func (c *Combs) Next() []int {
	c.i++
	for bits.OnesCount(uint(c.i)) != c.k {
		c.i++
	}
	return c.Get()
}

func (c *Combs) Get() []int {
	var subset []int
	for i := 0; i < c.n; i++ {
		if (c.i>>i)&1 == 1 {
			subset = append(subset, i)
		}
	}
	return subset
}
