const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const CW: usize = 0;
const CCW: usize = 1;

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    const players = try aoc.chompUint(u32, inp, &i);
    i += 31;
    const score = try aoc.chompUint(u32, inp, &i);
    var s = try aoc.halloc.alloc([2]u32, 8000000);
    const p1 = play(s[0..], players, score);
    const p2 = play(s[0..], players, score * 100);
    return [2]usize{ p1, p2 };
}

fn play(s: [][2]u32, players: usize, score: usize) usize {
    var scores: [512]u32 = .{0} ** 512;
    s[0][CW] = 0;
    s[0][CCW] = 0;
    var cur: usize = 0;
    for (1..score + 1) |m| {
        if (m % 23 == 0) {
            const p = (m - 1) % players;
            scores[p] += @as(u32, @intCast(m));
            for (0..7) |_| {
                cur = s[cur][CCW];
            }
            scores[p] += @as(u32, @intCast(cur));
            const ccw = s[cur][CCW];
            const cw = s[cur][CW];
            cur = cw;
            s[cw][CCW] = ccw;
            s[ccw][CW] = cw;
        } else {
            const ccw = s[cur][CW];
            const cw = s[s[cur][CW]][CW];
            const mu = @as(u32, @intCast(m));
            s[m][CW] = cw;
            s[m][CCW] = ccw;
            s[cw][CCW] = mu;
            s[ccw][CW] = mu;
            cur = mu;
        }
    }
    var max: usize = 0;
    for (0..players) |p| {
        const sc = @as(usize, @intCast(scores[p]));
        if (sc > max) {
            max = sc;
        }
    }
    return max;
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
