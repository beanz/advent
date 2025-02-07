const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var turn: [100]u8 = .{0} ** 100;
    var rev: [100]u8 = .{0} ** 100;
    var i: usize = 0;
    {
        var t: u8 = 0;
        while (true) : (i += 1) {
            const n = try aoc.chompUint(u8, inp, &i);
            turn[n] = t;
            rev[t] = n;
            t += 1;
            if (inp[i] == '\n') {
                break;
            }
        }
    }
    var it = aoc.uintIter(u8, inp[i..]);
    var board: [25]u8 = undefined;
    var turns: [25]u8 = undefined;
    var winTurn: u8 = std.math.maxInt(u8);
    var loseTurn: u8 = std.math.minInt(u8);
    var p1: usize = 0;
    var p2: usize = 0;
    while (uintFill(u8, &board, &it)) {
        for (0..25) |j| {
            turns[j] = turn[board[j]];
        }
        var min: u8 = std.math.maxInt(u8);
        inline for (0..5) |j| {
            var rmax: u8 = std.math.minInt(u8);
            var cmax: u8 = std.math.minInt(u8);
            inline for (0..5) |k| {
                cmax = @max(cmax, turns[j + 5 * k]);
                rmax = @max(rmax, turns[k + 5 * j]);
            }
            min = @min(min, @min(cmax, rmax));
        }
        var sum: usize = 0;
        for (board) |n| {
            if (turn[n] > min) {
                sum += @intCast(n);
            }
        }
        const score = sum * @as(usize, @intCast(rev[min]));
        if (min < winTurn) {
            winTurn = min;
            p1 = score;
        }
        if (min > loseTurn) {
            loseTurn = min;
            p2 = score;
        }
    }
    return [2]usize{ p1, p2 };
}

fn uintFill(comptime T: type, a: []T, it: *aoc.UintIter(T)) bool {
    for (0..a.len) |i| {
        a[i] = it.next() orelse return false;
    }
    return true;
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
