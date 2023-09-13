const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn loopSize(t: u64) u64 {
    var p: u64 = 1;
    var s: u64 = 7;
    var l: u64 = 0;
    while (p != t) {
        p *= s;
        p %= 20201227;
        l += 1;
    }
    return l;
}

test "loop size" {
    try aoc.assertEq(@as(u64, 8), loopSize(5764801));
    try aoc.assertEq(@as(u64, 11), loopSize(17807724));
    try aoc.assertEq(@as(u64, 13467729), loopSize(9033205));
    try aoc.assertEq(@as(u64, 3020524), loopSize(9281649));
}

fn expMod(ia: u64, ib: u64, m: u64) u64 {
    var a = ia;
    var b = ib;
    var c: u64 = 1;
    while (b > 0) : (b /= 2) {
        if ((b % 2) == 1) {
            c *= a;
            c %= m;
        }
        a *= a;
        a %= m;
    }
    return c;
}

pub fn part1(s: [][]const u8) !u64 {
    const cardPub = try std.fmt.parseUnsigned(u64, s[0], 10);
    const doorPub = try std.fmt.parseUnsigned(u64, s[1], 10);
    const ls = loopSize(cardPub);
    return expMod(doorPub, ls, 20201227);
}

test "part1" {
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    const rt = try part1(test1);
    try aoc.assertEq(@as(usize, 14897079), rt);
    const r = try part1(inp);
    try aoc.assertEq(@as(usize, 9714832), r);
}

fn day25(inp: []const u8, bench: bool) anyerror!void {
    const lines = try aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var p1 = part1(lines);
    if (!bench) {
        aoc.print("Part 1: {!}\n", .{p1});
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day25);
}
