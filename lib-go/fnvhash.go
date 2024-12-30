package aoc

const (
	p32 uint32 = 16777619
	o32 uint32 = 2166136261
	p64 uint64 = 1099511628211
	o64 uint64 = 14695981039346656037
)

type FnvHash[K AoCInt, V any] struct {
	array []*V
	mask  uint32
}

func NewFnvHash[K AoCInt, V any](a []*V, mask uint32) *FnvHash[K, V] {
	return &FnvHash[K, V]{a, mask}
}

func (h *FnvHash[K, V]) keyHash(k K) uint32 {
	var s uint32 = o32
	for {
		s ^= uint32(k) & uint32(0xff)
		s *= p32
		k >>= 8
		if k == 0 {
			break
		}
	}
	return s & h.mask
}

func (h *FnvHash[K, V]) Put(k K, v *V) {
	s := h.keyHash(k)
	if h.array[s] != nil {
		panic("hash clash")
	}
	h.array[s] = v
}

func (h *FnvHash[K, V]) Get(k K) (*V, bool) {
	s := h.keyHash(k)
	v := h.array[s]
	return v, v != nil
}

type FnvHash64[K AoCInt, V any] struct {
	array []*V
	mask  uint64
}

func NewFnvHash64[K AoCInt, V any](a []*V, mask uint64) *FnvHash64[K, V] {
	return &FnvHash64[K, V]{a, mask}
}

func (h *FnvHash64[K, V]) keyHash(k K) uint64 {
	var s uint64 = o64
	for {
		s ^= uint64(k) & uint64(0xff)
		s *= p64
		k >>= 8
		if k == 0 {
			break
		}
	}
	return s & h.mask
}

func (h *FnvHash64[K, V]) Put(k K, v *V) {
	s := h.keyHash(k)
	if h.array[s] != nil {
		panic("hash clash")
	}
	h.array[s] = v
}

func (h *FnvHash64[K, V]) Get(k K) (*V, bool) {
	s := h.keyHash(k)
	v := h.array[s]
	return v, v != nil
}
