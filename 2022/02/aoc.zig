const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const S1 = [_]usize{ 0, 0, 0, 0, 4, 8, 3, 0, 1, 5, 9, 0, 7, 2, 6 };
const S2 = [_]usize{ 0, 0, 0, 0, 3, 4, 8, 0, 1, 5, 9, 0, 2, 6, 7 };

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 4) {
        const s: usize = @intCast(((inp[i] & 0x3) << 2) + (inp[i + 2] & 0x3));
        p1 += S1[s];
        p2 += S2[s];
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
