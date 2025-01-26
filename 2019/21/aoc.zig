const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PROG_CAP: usize = 4096;
const HULL_DATA: usize = 758;
const HULL_END: usize = 758 + 162;

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
    var p1: ?usize = null;
    var p2: usize = 0;
    for (HULL_DATA..HULL_END) |a| {
        const holes: usize = @intCast(prog[a]);
        const score = holesScore(holes);
        p2 += score * a * holes;
        if (p1 == null and holes == 0) {
            p1 = p2;
        }
    }
    return [2]usize{ p1.?, p2 };
}

fn holesScore(x: usize) usize {
    var sc: usize = 0;
    var bit: usize = 1;
    inline for (0..9) |b| {
        if (x & bit == 0) {
            sc += 18 - b;
        }
        bit <<= 1;
    }
    return sc;
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
