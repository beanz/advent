const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var n: usize = 0;
    var p: [6]u5 = undefined;
    var pl: usize = 0;
    {
        while (pl < inp.len - 1) : (pl += 1) {
            const ch = inp[pl] - '0';
            p[pl] = @as(u5, @intCast(ch));
            n = 10 * n + @as(usize, @intCast(ch));
        }
    }
    var scores = try aoc.halloc.alloc(u5, 20480000);
    scores[0] = 3;
    scores[1] = 7;
    var a: usize = 0;
    var b: usize = 1;
    var l: usize = 2;
    while (l < scores.len) {
        const v = scores[a] + scores[b];
        if (v < 10) {
            scores[l] = v;
            l += 1;
        } else {
            scores[l] = 1;
            l += 1;
            scores[l] = v - 10;
            l += 1;
        }
        a = (a + 1 + @as(usize, scores[a])) % l;
        b = (b + 1 + @as(usize, scores[b])) % l;
    }
    var p1: usize = 0;
    for (0..10) |j| {
        p1 = p1 * 10 + @as(usize, scores[n + j]);
    }
    return [2]usize{ p1, std.mem.indexOf(u5, scores, p[0..pl]).? };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {:0>10}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
