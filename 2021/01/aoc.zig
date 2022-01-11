const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    var scan = try aoc.Ints(aoc.talloc, i64, aoc.test1file);
    defer aoc.talloc.free(scan);
    try aoc.assertEq(@as(usize, 7), part1(scan));
    try aoc.assertEq(@as(usize, 5), part2(scan));
    var scan2 = try aoc.Ints(aoc.talloc, i64, aoc.inputfile);
    defer aoc.talloc.free(scan2);
    try aoc.assertEq(@as(usize, 1342), part1(scan2));
    try aoc.assertEq(@as(usize, 1378), part2(scan2));
}

fn calc(exp: []const i64, n: usize) usize {
    var i: usize = n;
    var c: usize = 0;
    while (i < exp.len) : (i += 1) {
        if (exp[i - n] < exp[i]) {
            c += 1;
        }
    }
    return c;
}

fn part1(exp: []const i64) usize {
    return calc(exp, 1);
}

fn part2(exp: []const i64) usize {
    return calc(exp, 3);
}

fn day01(inp: []const u8, bench: bool) anyerror!void {
    var scan = try aoc.Ints(aoc.halloc, i64, inp);
    defer aoc.halloc.free(scan);
    var p1 = part1(scan);
    var p2 = part2(scan);
    if (!bench) {
        try aoc.print("Part1: {}\nPart2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day01);
}
