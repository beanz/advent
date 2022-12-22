package aoc

func Abs[T AoCSigned](x T) T {
	if x < 0 {
		return -x
	}
	return x
}

func Mod[T AoCSigned](n, m T) T {
	a := n % m
	if a < 0 {
		a += m
	}
	return a
}

func NeverToBigMod[T AoCSigned](n, m T) T {
	if n < 0 {
		return n + m
	} else if n >= m {
		return n - m
	}
	return n
}

func Abs64(a int64) int64 {
	if a < 0 {
		return -a
	}
	return a
}

func GCD(a, b int64) int64 {
	a = Abs64(a)
	b = Abs64(b)
	if a > b {
		a, b = b, a
	}
	for a != 0 {
		a, b = (b % a), a
	}
	return b
}

func LCM(a, b int64, integers ...int64) int64 {
	result := a * b / GCD(a, b)
	for i := 0; i < len(integers); i++ {
		result = LCM(result, integers[i])
	}
	return result
}

func ModExp(b, e, m uint) uint {
	var res uint = 1
	for e > 0 {
		if (e % 2) == 1 {
			res = (res * b) % m
		}
		e = e / 2
		b = (b * b) % m
	}
	return res
}

func Product(ints ...int) int {
	p := 1
	for _, x := range ints {
		p *= x
	}
	return p
}

func Product64(ints ...int64) int64 {
	var p int64 = 1
	for _, x := range ints {
		p *= x
	}
	return p
}

func Sum(ints ...int) int {
	s := 0
	for _, x := range ints {
		s += x
	}
	return s
}

func Sum64(ints ...int64) int64 {
	var s int64 = 0
	for _, x := range ints {
		s += x
	}
	return s
}

func MinInt(a ...int) int {
	min := a[0]
	for i := 1; i < len(a); i++ {
		if a[i] < min {
			min = a[i]
		}
	}
	return min
}

func MaxInt(a ...int) int {
	max := a[0]
	for i := 1; i < len(a); i++ {
		if a[i] > max {
			max = a[i]
		}
	}
	return max
}

func MinInt64(a ...int64) int64 {
	min := a[0]
	for i := 1; i < len(a); i++ {
		if a[i] < min {
			min = a[i]
		}
	}
	return min
}

func MaxInt64(a ...int64) int64 {
	max := a[0]
	for i := 1; i < len(a); i++ {
		if a[i] > max {
			max = a[i]
		}
	}
	return max
}
