const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var i: usize = 96;
    while (i < inp.len) {
        const w = try aoc.chompUint(usize, inp, &i);
        i += 1;
        const h = try aoc.chompUint(usize, inp, &i);
        const a = w * h;
        i += 2;
        var b: usize = 0;
        for (0..6) |_| {
            const n = try aoc.chompUint(usize, inp, &i);
            b += n * 9;
            i += 1;
        }
        if (a >= b) {
            p1 += 1;
        }
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
