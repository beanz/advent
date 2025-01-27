const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const l0 = try aoc.chompUint(u32, inp, &i);
        i += 1;
        const h0 = try aoc.chompUint(u32, inp, &i);
        i += 1;
        const l1 = try aoc.chompUint(u32, inp, &i);
        i += 1;
        const h1 = try aoc.chompUint(u32, inp, &i);
        p1 += @intFromBool((l0 >= l1 and h0 <= h1) or (l1 >= l0 and h1 <= h0));
        p2 += @intFromBool(!(l0 > h1 or l1 > h0));
    }

    return [2]usize{ p1, p2 };
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
