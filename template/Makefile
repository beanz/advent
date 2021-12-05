DAY=$(notdir $(CURDIR))
YEAR=$(notdir $(patsubst %/,%,$(dir $(CURDIR))))
HERE=$(YEAR)/$(DAY)

CC=clang++-6.0
CR_DIR=$(HOME)/Tmp/crystal-0.35.1-1
CR_LIB=$(CR_DIR)/share/crystal/src:../../lib-cr
CR=$(CR_DIR)/bin/crystal
#NIM=$(HOME)/Tmp/nim-1.0.4/bin/nim
NIM=$(HOME)/Tmp/nim-1.4.2/bin/nim

ifneq (,$(wildcard main.go))
ALL += aoc-go
CLEAN += aoc-go
HYPERFINE += aoc-go
endif
ifneq (,$(wildcard aoc.pl))
ALL += aoc.pl
HYPERFINE += aoc.pl
endif
ifneq (,$(wildcard aoc.zig))
ALL += aoc-zig
CLEAN += aoc-zig
HYPERFINE += aoc-zig-rel
endif
ifneq (,$(wildcard aoc.cr))
ALL += aoc-cr
CLEAN += aoc-cr
HYPERFINE += aoc-cr-rel
endif
ifneq (,$(wildcard aoc.nim))
ALL += aoc-nim
CLEAN += aoc-nim
HYPERFINE += aoc-nim-rel
endif
ifneq (,$(wildcard cpp/aoc.cpp))
ALL += aoc-cpp
CLEAN += aoc-cpp
HYPERFINE += aoc-cpp
endif
RS_SRC=../../aoc-rust/src/bin/aoc-$(YEAR)-$(DAY).rs
RS_BIN=$(subst src/bin,target/release,${RS_SRC:.rs=})
RS_REL=$(subst src/bin,target/debug,${RS_SRC:.rs=})

#ifneq (,$(wildcard $(RS_SRC)))
#ALL += aoc-rs
#CLEAN += aoc-rs
#HYPERFINE += aoc-rs-rel
#endif
ifneq (,$(wildcard aoc.jq))
ALL += aoc.jq
endif
TIMES=$(addsuffix -time,${ALL})

EXTRA=aoc-gccgo aoc-zig-rel gocpu.out aoc-cr-rel cr-cpu.svg \
  zig-cpu.svg perf.data perf.data.old
FG_HOME=$(HOME)/git/github/brendangregg/FlameGraph

all: input.txt ${ALL}

clean:
	-rm -f ${CLEAN} $(notdir $(CURDIR)).test ${EXTRA}
	-rm -rf aoc-lib.zig zig-cache nytprof nytprof.out _Inline
	-find . -name '*~' -print0 |xargs -0 rm -f

times: input.txt ${TIMES}

%-time: %
	@echo $<
	@/usr/bin/time ./$<
	@echo

hyperfine: ${HYPERFINE}
	hyperfine --warmup 1 $(addprefix ./,${HYPERFINE})

input.txt:
	aoc-dump

aoc-cpp: cpp/aoc.cpp ../../lib-cpp/*.hpp
	$(CC) -I../../lib-cpp -o $@ $<

aoc-cr: aoc.cr ../../lib-cr/*.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build -o aoc-cr aoc.cr

aoc-cr-rel: aoc.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build --release --debug -o $@ $<

aoc-nim: aoc.nim ../../lib-nim/*.nim
	$(NIM) c --path:../../lib-nim $<
	mv aoc $@

aoc-nim-rel: aoc.nim ../../lib-nim/*.nim
	$(NIM) c --checks:off --assertions:off --opt:speed -d:release \
	         --path:../../lib-nim $<
	mv aoc $@

aoc-lib.zig: ../../lib-zig/aoc-lib.zig
	ln -s $< $@

aoc-zig: aoc.zig aoc-lib.zig
	zig build-exe --name $@ $<

aoc-zig-rel: aoc.zig
	zig build-exe -O ReleaseSmall --name $@ $<

aoc-go: main.go
	go build -o $@ $<

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

check: ${ALL}
	@TT=$$(mktemp -d) ; \
	GOLD=$$TT/gold.log ; \
	./$< >$$GOLD ; \
	echo -n "$(HERE): " ; \
	for f in $^ ; do \
	  echo -n "$$f "; \
	  ./$$f >$$TT/$$f.log \
	    && diff -udBbw $$GOLD $$TT/$$f.log \
	    || ( echo ; echo $$f output differs ); \
	done && \
	  rm -rf $$TT ; \
	echo

aoc-rs: $(RS_SRC)
	echo $(RS_SRC) && cd ../../aoc-rust && cargo build --bin "$(notdir $@)" && \
	  mv $(RS_BIN) $@

aoc-rs-rel: $(RS_SRC)
	cd ../../aoc-rust && cargo build --release --bin "$(notdir $@)" && \
	  mv $(RS_REL) $@
