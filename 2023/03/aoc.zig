const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    try aoc.TestCases(u32, parts);
}

const NOT_FOUND: usize = 9999999;

fn parts(inp: []const u8) ![2]u32 {
    var p1: u32 = 0;
    var p2: u32 = 0;
    var w: usize = 0;
    while (inp[w] != '\n') : (w += 1) {}
    w += 1;
    var i: usize = 0;
    var seen = std.mem.zeroes([141 * 141]u32);
    while (i < inp.len) {
        const ch = inp[i];
        if (!isDigit(ch)) {
            i += 1;
            continue;
        }
        var n = @as(u32, ch - '0');
        var j = i + 1;
        while (j < inp.len and isDigit(inp[j])) : (j += 1) {
            n = n * 10 + @as(u32, inp[j] - '0');
        }
        const l = j - i;
        i = j;
        const k = symbol(inp, j - l, l, w) orelse continue;
        const sym = inp[k];
        p1 += n;
        if (sym == '*') {
            if (seen[k] != 0) {
                p2 += seen[k] * n;
            } else {
                seen[k] = n;
            }
        }
    }
    return [2]u32{ p1, p2 };
}

fn is_symbol(ch: u8) bool {
    return ch != '.' and ch != '\n' and !isDigit(ch);
}

fn symbol(inp: []const u8, i: usize, l: usize, w: usize) ?usize {
    for ((w - l)..(w + 2)) |o| {
        if (i >= o and is_symbol(inp[i - o])) {
            return i - o;
        }
    }
    if (i > 0 and is_symbol(inp[i - 1])) {
        return i - 1;
    }
    if (i + l < inp.len and is_symbol(inp[i + l])) {
        return i + l;
    }
    for ((i + w - 1)..(i + w + l + 1)) |j| {
        if (j < inp.len and is_symbol(inp[j])) {
            return j;
        }
    }
    return null;
}

fn day01(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day01);
}
