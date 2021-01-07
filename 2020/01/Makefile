CC=clang++-6.0
CR_DIR=$(HOME)/Tmp/crystal-0.35.1-1
CR_LIB=$(CR_DIR)/share/crystal/src:../../lib-cr
CR=$(CR_DIR)/bin/crystal
ALL=aoc-go aoc-zig aoc-cr
EXTRA=aoc-gccgo aoc-zig-rel gocpu.out aoc-cr-rel cr-cpu.svg \
  zig-cpu.svg perf.data perf.data.old
FG_HOME=$(HOME)/git/github/brendangregg/FlameGraph

all: input.txt ${ALL}

clean:
	-rm -f ${ALL} $(notdir $(CURDIR)).test ${EXTRA}
	-rm -rf zig-cache nytprof nytprof.out _Inline
	-find . -name '*~' -print0 |xargs -0 rm -f

times: ${ALL} input.txt
	@echo aoc-go
	@time ./aoc-go input.txt
	@echo
	@echo aoc-zig
	@time ./aoc-zig
	@echo
	@echo aoc.pl
	@time perl aoc.pl input.txt
	@echo
	@echo aoc-cr
	@time ./aoc-cr
	@echo
	@if [ -f aoc.jq ]; then \
	  echo aoc.jq ; \
	  time ./aoc.jq < input.txt ; \
	  echo ; \
	fi

input.txt:
	aoc-dump

aoc-cr: aoc.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build -o aoc-cr aoc.cr

aoc-cr-rel: aoc.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build --release --debug -o $@ $<

aoc-zig: aoc.zig
	zig build-exe --name $@ $<

aoc-zig-rel: aoc.zig
	zig build-exe -O ReleaseSmall --name $@ $<

aoc-go: main.go
	go build $<
	mv main $@

aoc-gccgo: main.go
	 go build -a -compiler gccgo -gccgoflags=all='-flto -Os -fdata-sections -ffunction-sections -Wl,--gc-sections,-s' $<
	mv main $@

gocpu.out: main.go
	go test -cpuprofile=$@

go-prof: gocpu.out
	go tool pprof -http=":9999" $<

cr-cpu.svg: aoc-cr-rel
	perf record -F 99 --call-graph dwarf ./$<
	perf script | $(FG_HOME)/stackcollapse-perf.pl >out.perf-folded
	$(FG_HOME)/flamegraph.pl out.perf-folded >$@
	-rm -f out.perf-folded perf.data perf.data.old

cr-prof: cr-cpu.svg
	google-chrome $<

zig-cpu.svg: aoc-zig
	perf record -F 99 --call-graph dwarf ./$<
	perf script | $(FG_HOME)/stackcollapse-perf.pl >out.perf-folded
	$(FG_HOME)/flamegraph.pl out.perf-folded >$@
	-rm -f out.perf-folded perf.data perf.data.old

zig-prof: zig-cpu.svg
	google-chrome $<

test: ${ALL}
	zig test aoc.zig
	go test -v
	AoC_TEST=2 perl aoc.pl input.txt

test-zig: aoc-zig
	zig test aoc.zig

test-go:
	go test -v

test-pl:
	AoC_TEST=2 perl aoc.pl input.txt

perl-prof:
	perl -d:NYTProf aoc.pl input.txt
	nytprofhtml --open
