const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}
const SIZE = 800;

fn parts(inp: []const u8) anyerror![2]usize {
    var gen: [SIZE]bool = .{false} ** SIZE;
    var rules: [32]bool = .{false} ** 32;
    var l: usize = undefined;
    {
        var i: usize = 15;
        while (inp[i] != '\n') : (i += 1) {
            gen[i - 15] = inp[i] == '#';
        }
        l = i - 15;
        i += 2;
        while (i < inp.len) {
            if (inp[i + 9] == '#') {
                rules[(@as(usize, @intFromBool(inp[i] == '#')) << 4) + (@as(usize, @intFromBool(inp[i + 1] == '#')) << 3) + (@as(usize, @intFromBool(inp[i + 2] == '#')) << 2) + (@as(usize, @intFromBool(inp[i + 3] == '#')) << 1) + @as(usize, @intFromBool(inp[i + 4] == '#'))] = true;
            }
            i += 11;
        }
    }

    var offset: usize = 0;
    var p1: usize = 0;
    var p2: usize = 0;
    var prev_score: isize = 0;
    var prev_diff: isize = 0;
    for (1..200) |g| {
        l += 4;
        var state: usize = 0;
        for (0..l) |i| {
            state = ((state << 1) & 0x1f) + @as(usize, @intFromBool(gen[i]));
            gen[i] = rules[state];
        }
        offset += 2;
        const sc = score(gen[0..l], offset);
        const diff = sc - prev_score;
        if (prev_diff == diff and g > 100) {
            const rem: isize = @intCast(50000000000 - g);
            p2 = @as(usize, @intCast(sc + diff * rem));
            break;
        }
        prev_score = sc;
        prev_diff = diff;
        if (g == 20) {
            p1 = @intCast(sc);
        }
    }
    return [2]usize{ p1, p2 };
}

fn score(pots: []bool, offset: usize) isize {
    const o: isize = @intCast(offset);
    var s: isize = 0;
    var i: isize = 0;
    for (pots) |p| {
        s += (i - o) * @as(isize, @intFromBool(p));
        i += 1;
    }
    return s;
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
