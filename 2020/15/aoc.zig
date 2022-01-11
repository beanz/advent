const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn calc(alloc: std.mem.Allocator, nums: []const usize, maxTurn: usize) usize {
    var lastSeen = alloc.alloc(usize, maxTurn) catch unreachable;
    defer alloc.free(lastSeen);
    std.mem.set(usize, lastSeen, 0);
    var n: usize = undefined;
    var p: usize = undefined;
    var t: usize = 1;
    while (t <= nums.len) : (t += 1) {
        n = nums[t - 1];
        if (t > 1) {
            lastSeen[p] = t;
        }
        p = n;
    }
    while (t <= maxTurn) : (t += 1) {
        if (lastSeen[p] != 0) {
            n = t - lastSeen[p];
        } else {
            n = 0;
        }
        lastSeen[p] = t;
        p = n;
    }
    return n;
}

fn part1(alloc: std.mem.Allocator, in: []const usize) usize {
    return calc(alloc, in, 2020);
}

fn part2(alloc: std.mem.Allocator, in: []const usize) usize {
    return calc(alloc, in, 30000000);
}

test "examples" {
    const test1 = try aoc.Ints(aoc.talloc, usize, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = try aoc.Ints(aoc.talloc, usize, aoc.test2file);
    defer aoc.talloc.free(test2);
    const test3 = try aoc.Ints(aoc.talloc, usize, aoc.test3file);
    defer aoc.talloc.free(test3);
    const test4 = try aoc.Ints(aoc.talloc, usize, aoc.test4file);
    defer aoc.talloc.free(test4);
    const test5 = try aoc.Ints(aoc.talloc, usize, aoc.test5file);
    defer aoc.talloc.free(test5);
    const test6 = try aoc.Ints(aoc.talloc, usize, aoc.test6file);
    defer aoc.talloc.free(test6);
    const test7 = try aoc.Ints(aoc.talloc, usize, aoc.test7file);
    defer aoc.talloc.free(test7);
    const inp = try aoc.Ints(aoc.talloc, usize, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(usize, 436), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 1), part1(aoc.talloc, test2));
    try aoc.assertEq(@as(usize, 10), part1(aoc.talloc, test3));
    try aoc.assertEq(@as(usize, 27), part1(aoc.talloc, test4));
    try aoc.assertEq(@as(usize, 78), part1(aoc.talloc, test5));
    try aoc.assertEq(@as(usize, 438), part1(aoc.talloc, test6));
    try aoc.assertEq(@as(usize, 1836), part1(aoc.talloc, test7));
    try aoc.assertEq(@as(usize, 260), part1(aoc.talloc, inp));

    try aoc.assertEq(@as(usize, 175594), part2(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 2578), part2(aoc.talloc, test2));
    try aoc.assertEq(@as(usize, 3544142), part2(aoc.talloc, test3));
    try aoc.assertEq(@as(usize, 261214), part2(aoc.talloc, test4));
    try aoc.assertEq(@as(usize, 6895259), part2(aoc.talloc, test5));
    try aoc.assertEq(@as(usize, 18), part2(aoc.talloc, test6));
    try aoc.assertEq(@as(usize, 362), part2(aoc.talloc, test7));
    try aoc.assertEq(@as(usize, 950), part2(aoc.talloc, inp));
}

fn day15(inp: []const u8, bench: bool) anyerror!void {
    const ints = try aoc.Ints(aoc.halloc, usize, inp);
    defer aoc.halloc.free(ints);
    var p1 = part1(aoc.halloc, ints);
    var p2 = part2(aoc.halloc, ints);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day15);
}
