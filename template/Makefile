DAY=$(notdir $(CURDIR))
YEAR=$(notdir $(patsubst %/,%,$(dir $(CURDIR))))
HERE=$(YEAR)/$(DAY)

CCC=clang++
CR_LIB=../../lib-cr
CR=crystal
NIM=nim

ifneq (,$(wildcard main.go))
ALL += aoc-go
CHECK += aoc-go
CLEAN += aoc-go gocpu.out cover.out gomem.out
TEST += test-go
HYPERFINE += aoc-go
endif
ifneq (,$(wildcard aoc.pl))
ALL += aoc.pl
#HYPERFINE += aoc.pl
TEST += test-pl
endif
ifneq (,$(wildcard aoc.raku))
ALL += aoc.raku
#HYPERFINE += aoc.pl
TEST += test-raku
endif
ifneq (,$(wildcard aoc.zig))
ALL += aoc-zig
CHECK += aoc-zig-rel
CLEAN += aoc-zig aoc-zig-rel aoc-lib.zig zig-cpu.svg
CLEAN_DIR += zig-cache
TEST += test-zig
HYPERFINE += aoc-zig-rel
endif
ifneq (,$(wildcard aoc.d))
ALL += aoc-d
CHECK += aoc-d
CLEAN += aoc-d aoc-d.o aoc-d-rel aoc-d-rel.o
HYPERFINE += aoc-d-rel
endif
ifneq (,$(wildcard aoc.cr))
ALL += aoc-cr
CHECK += aoc-cr-rel
CLEAN += aoc-cr aoc-cr-rel cr-cpu.svg
HYPERFINE += aoc-cr-rel
endif
ifneq (,$(wildcard aoc.nim))
ALL += aoc-nim
CHECK += aoc-nim-rel
CLEAN += aoc-nim
HYPERFINE += aoc-nim-rel
endif
ifneq (,$(wildcard cpp/aoc.cpp))
ALL += aoc-cpp
CHECK += aoc-cpp-rel
CLEAN += aoc-cpp
HYPERFINE += aoc-cpp-rel
endif
ifneq (,$(wildcard aoc.hs))
ALL += aoc-hs
CHECK += aoc-hs-rel
CLEAN += aoc-hs aoc-hs-rel
HYPERFINE += aoc-hs-rel
endif

# TODO: fix rust builds
RS_SRC=../../aoc-rust/src/bin/aoc-$(YEAR)-$(DAY).rs
RS_BIN=$(subst src/bin,target/debug,${RS_SRC:.rs=})
RS_REL=$(subst src/bin,target/release,${RS_SRC:.rs=})
ifneq (,$(wildcard $(RS_SRC)))
ALL += aoc-rs
CHECK += aoc-rs-rel
CLEAN += aoc-rs
HYPERFINE += aoc-rs-rel
TEST += test-rs
endif

ifneq (,$(wildcard aoc.jq))
ALL += aoc.jq
endif
TIMES=$(addsuffix -time,${ALL})

EXTRA=aoc-gccgo out.perf-folded perf.data perf.data.old
FG_HOME=$(HOME)/git/github.com/brendangregg/FlameGraph
INPUTS=$(wildcard ../../input/$(YEAR)/$(DAY)/*.txt)

all: $(notdir $(INPUTS)) ${ALL}

clean:
	-rm -f ${CLEAN} $(notdir $(CURDIR)).test ${EXTRA} *.err *.log *.chk
	-rm -rf ${CLEAN_DIR} nytprof nytprof.out _Inline
	-find . -name '*~' -print0 |xargs -0 rm -f

times: input.txt ${TIMES}

%-time: %
	@echo $<
	@/usr/bin/time ./$<
	@echo

hyperfine: ${HYPERFINE}
	hyperfine -N --warmup 1 $(addprefix ./,${HYPERFINE})

%.txt: ../../input/$(YEAR)/$(DAY)/%.txt
	cp $< $@

aoc-cpp: cpp/aoc.cpp ../../lib-cpp/*.hpp cpp/input.h
	$(CCC) -I../../lib-cpp -o $@ $<

aoc-cpp-rel: cpp/aoc.cpp ../../lib-cpp/*.hpp cpp/input.h
	$(CCC) -I../../lib-cpp -O3 -o $@ $<

cpp/input.h: input.txt
	xxd -i $< $@

aoc-cr: aoc.cr ../../lib-cr/*.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build -o aoc-cr aoc.cr

aoc-cr-rel: aoc.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build --release --debug -o $@ $<

aoc-hs: aoc.hs
	ghc -i ../../lib-hs/Utils.hs -o $@ $<

aoc-hs-rel: aoc.hs
	ghc -i ../../lib-hs/Utils.hs -O3 -o $@ $<

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

aoc-zig-rel: aoc.zig aoc-lib.zig
	zig build-exe -O ReleaseFast --name $@ $<

aoc-d: aoc.d
	dmd -J. -of=$@ $<

aoc-d-rel: aoc.d
	dmd -release -boundscheck=off -O -J. -of=$@ $<

aoc-go: main.go input.txt
	go build -o $@

aoc-gccgo: main.go
	 go build -a -compiler gccgo -gccgoflags=all='-flto -Os -fdata-sections -ffunction-sections -Wl,--gc-sections,-s' $<
	mv main $@

gocpu.out: main.go
	BENCHTIME=5s ; \
	if [ -f .aoc-go.benchtime ]; then BENCHTIME=$$(cat .aoc-go.benchtime); fi;\
	go test $$(grep -q Bench *_test.go && echo "-run=XXX -benchmem -benchtime=$$BENCHTIME -bench .") -cpuprofile=$@ -memprofile=gomem.out

go-prof: gocpu.out
	go tool pprof -http=":9999" $<

go-cover: main.go main_test.go
	go test -coverprofile cover.out
	go tool cover -html=cover.out
	rm cover.out

cr-cpu.svg: aoc-cr-rel
	AoC_BENCH=1 perf record -F 99 --call-graph dwarf ./$<
	perf script | $(FG_HOME)/stackcollapse-perf.pl >out.perf-folded
	$(FG_HOME)/flamegraph.pl out.perf-folded >$@
	perf report -g fractal -F+period,srcline
	-rm -f out.perf-folded perf.data perf.data.old

cr-prof: cr-cpu.svg
	google-chrome $<

zig-cpu.svg: aoc-zig
	AoC_BENCH=1 perf record -F 99 --call-graph dwarf ./$<
	perf script | $(FG_HOME)/stackcollapse-perf.pl >out.perf-folded
	$(FG_HOME)/flamegraph.pl out.perf-folded >$@
	perf report -g fractal -F+period,srcline
	-rm -f out.perf-folded perf.data perf.data.old

zig-prof: zig-cpu.svg
	google-chrome $<

test: ${TEST}

test-zig: aoc-zig
	zig test aoc.zig

test-go:
	go test -v

test-go-fast:
	go test -short

test-pl:
	AoC_TEST=2 perl aoc.pl input.txt

test-raku:
	AoC_TEST=2 ./aoc.raku input.txt

perl-prof:
	perl -d:NYTProf aoc.pl input.txt
	nytprofhtml --open

check: ${ALL}
	@TT=$$(mktemp -d) ; \
	GOLD=$$TT/gold.log ; \
	./$< >$$GOLD ; \
	echo -n "$(HERE): " ; \
	for f in $^ ; do \
	  test -f ".$$f.slow" && continue ; \
	  if [ "$<" = "$$f" ]; then echo -n "$$f "; continue ; fi; \
	  echo -n "$$f "; \
	  ./$$f >$$TT/$$f.log 2>&1 \
	    && diff -audBbw $$GOLD $$TT/$$f.log >$$TT/$$f.diff \
	    || ( echo ; echo $$f output differs ; cat $$TT/$$f.diff); \
	done && \
	  rm -rf $$TT ; \
	echo

aoc-rs: $(RS_SRC)
	( cd ../../aoc-rust && \
	  cargo build --bin "$(basename $(notdir $<))" ) && \
	mv $(RS_BIN) $@

aoc-rs-rel: $(RS_SRC)
	( cd ../../aoc-rust && \
	  cargo build --release --bin "$(basename $(notdir $<))" ) && \
	mv $(RS_REL) $@

test-rs: $(RS_SRC)
	( cd ../../aoc-rust && \
	  RUST_MIN_STACK=8388608 cargo test --bin "$(basename $(notdir $<))" )

prof-rs: $(RS_SRC)
	( cd ../../aoc-rust && \
	  AoC_BENCH=1 cargo flamegraph --bin "$(basename $(notdir $<))" \
		   -o ../$(YEAR)/$(DAY)/flamegraph.svg \
		   -- ../$(YEAR)/$(DAY)/input.txt ; \
		echo )

test-rs-cov: $(RS_SRC)
	( cd ../../aoc-rust && \
	  RUSTFLAGS="-C instrument-coverage" \
		  cargo test --bin "$(basename $(notdir $<))" )
	llvm-profdata merge -sparse ../../aoc-rust/default_*.profraw -o test.profdata
	llvm-cov report \
    --use-color \
		--ignore-filename-regex='/.cargo/registry' \
		--ignore-filename-regex='src/lib.rs' \
    --instr-profile=test.profdata \
    --object ../../aoc-rust/target/debug/deps/aoc_$(YEAR)_$(DAY)-????????????????
	llvm-cov show \
    --use-color \
		--ignore-filename-regex='/.cargo/registry' \
		--ignore-filename-regex='src/lib.rs' \
    --instr-profile=test.profdata \
    --object ../../aoc-rust/target/debug/deps/aoc_$(YEAR)_$(DAY)-???????????????? \
    --show-instantiations --show-line-counts-or-regions \
    --Xdemangler=rustfilt

clippy: $(RS_SRC)
	( cd ../../aoc-rust && cargo clippy )

expect-pl: aoc.pl
	@if [ -z "$$AoC_E" ]; then echo 2>&1 "AoC_E must be set"; exit 1; fi
	@while true; do perl aoc.pl $${TEST:-test1.txt} | tee /dev/stderr |grep -Fq "$$AoC_E" && break; sleep 1; done; perl aoc.pl

expect-go: aoc-go
	@if [ -z "$$AoC_E" ]; then echo 2>&1 "AoC_E must be set"; exit 1; fi
	@while true; do go build -o aoc-go && ./aoc-go $${TEST:-test1.txt} |tee /dev/stderr |grep -Fq "$$AoC_E" && break; sleep 1; done; ./aoc-go

template:
	@if [ ! -e Makefile ]; then ln -s ../../template/Makefile . ; fi ; \
	for f in aoc.pl main.go main_test.go aoc.raku aoc.zig TC.txt; do \
	  if [ ! -e $$f ]; then \
		  echo copying $$f ; cp -p ../../template/$$f . ; \
  	fi \
	done ; \
	frs="../../aoc-rust/src/bin/aoc-$(YEAR)-$(DAY).rs" ; \
	if [ ! -e $$frs ]; then \
	  echo copying aoc-yyyy-dd.rs ; \
		sed -e's/YYYY/'"$(YEAR)"'/g;s/DD/'"$(DAY)"'/g' \
		  <../../template/aoc-yyyy-dd.rs >$$frs; \
	fi
