const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var it = aoc.uintIter(u32, inp);
    while (it.next()) |a1| {
        const b1 = it.next().?;
        const c1 = it.next().?;
        const a2 = it.next().?;
        const b2 = it.next().?;
        const c2 = it.next().?;
        const a3 = it.next().?;
        const b3 = it.next().?;
        const c3 = it.next().?;
        p1 += @intFromBool(a1 + b1 > c1 and a1 + c1 > b1 and b1 + c1 > a1);
        p1 += @intFromBool(a2 + b2 > c2 and a2 + c2 > b2 and b2 + c2 > a2);
        p1 += @intFromBool(a3 + b3 > c3 and a3 + c3 > b3 and b3 + c3 > a3);
        p2 += @intFromBool(a1 + a2 > a3 and a1 + a3 > a2 and a2 + a3 > a1);
        p2 += @intFromBool(b1 + b2 > b3 and b1 + b3 > b2 and b2 + b3 > b1);
        p2 += @intFromBool(c1 + c2 > c3 and c1 + c3 > c2 and c2 + c3 > c1);
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
