const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn parts(alloc: std.mem.Allocator, inp: []const u8) ![2]u16 {
    const si = std.mem.indexOfScalar(u8, inp, @as(u8, '\n')) orelse unreachable;
    const calls = try aoc.Ints(alloc, u8, inp[0..si]);
    defer alloc.free(calls);
    var rounds: @Vector(100, u8) = @splat(@as(u8, 101));
    for (calls, 0..) |v, i| {
        rounds[v] = @as(u8, @intCast(i));
    }
    var res = [2]u16{ 0, 0 };
    var first: u8 = 255;
    var last: u8 = 0;
    var boardInts = try aoc.Ints(alloc, u8, inp[si + 2 ..]);
    defer alloc.free(boardInts);
    var boardI: usize = 0;
    while (boardI < boardInts.len) : (boardI += 25) {
        const board = boardInts[boardI .. boardI + 25];
        var rl = [10]u8{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        for (board, 0..) |v, i| {
            const round = rounds[v];
            const r = i % 5;
            const c = @divFloor(i, 5);
            if (rl[r] < round) {
                rl[r] = round;
            }
            if (rl[c + 5] < round) {
                rl[c + 5] = round;
            }
        }
        const min = std.mem.min(u8, rl[0..]);
        var sc: u16 = 0;
        for (board) |v| {
            if (rounds[v] > min) {
                sc += @as(u16, v);
            }
        }
        if (first > min) {
            first = min;
            res[0] = calls[min] * sc;
        }
        if (last < min) {
            last = min;
            res[1] = calls[min] * sc;
        }
    }
    return res;
}

test "parts" {
    var t = try parts(aoc.talloc, aoc.test1file);
    try aoc.assertEq(@as(u16, 4512), t[0]);
    try aoc.assertEq(@as(u16, 1924), t[1]);
    t = try parts(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(u16, 63552), t[0]);
    try aoc.assertEq(@as(u16, 9020), t[1]);
}

fn day04(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(aoc.halloc, inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day04);
}
