package aoc

func Abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
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
	result := a * b / gcd(a, b)
	for i := 0; i < len(integers); i++ {
		result = lcm(result, integers[i])
	}
	return result
}
