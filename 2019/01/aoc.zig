const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u32;

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: Int = 0;
    var p2: Int = 0;
    var it = aoc.uintIter(Int, inp);
    while (it.next()) |n| {
        p1 += fuel1(n);
        p2 += fuel2(n);
    }
    return [2]usize{ p1, p2 };
}

inline fn fuel1(m: Int) Int {
    return @divFloor(m, 3) - 2;
}

test "fuel1" {
    try aoc.assertEq(2, fuel1(12));
    try aoc.assertEq(2, fuel1(14));
    try aoc.assertEq(654, fuel1(1969));
    try aoc.assertEq(33583, fuel1(100756));
}

fn fuel2(im: Int) Int {
    var s: Int = 0;
    var m: Int = im;
    while (true) {
        const v = @divFloor(m, 3);
        if (v <= 2) {
            return s;
        }
        m = v - 2;
        s += m;
    }
}

test "fuel2" {
    try aoc.assertEq(2, fuel2(14));
    try aoc.assertEq(966, fuel2(1969));
    try aoc.assertEq(50346, fuel2(100756));
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
