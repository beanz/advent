const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PROG_CAP: usize = 5120;
const ITEM_TABLE: usize = 4601;
const ROOM_LIST: usize = 3124;
const ITEM_DATA: usize = 1902;
const CUTOFF_A: usize = 1352;
const CUTOFF_B: usize = 2486;

const Int = i64;

fn parts(inp: []const u8) anyerror![2]usize {
    var p: [PROG_CAP]Int = undefined;
    var l: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            p[l] = try aoc.chompInt(Int, inp, &i);
            l += 1;
        }
    }
    const prog = p[0..l];
    const cutoff = prog[CUTOFF_A] * prog[CUTOFF_B];
    var bit: usize = 1 << 31;
    var p1: usize = 0;
    for (0..32) |i| {
        if (prog[ITEM_DATA + i] >= cutoff) {
            p1 |= bit;
        }
        bit >>= 1;
    }
    return [2]usize{ p1, 0 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
