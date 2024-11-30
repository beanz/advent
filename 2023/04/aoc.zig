const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    try aoc.TestCases(u32, parts);
}

fn parts(inp: []const u8) anyerror![2]u32 {
    var p1: u32 = 0;
    var p2: u32 = 0;
    var i: usize = 0;
    var copies = try std.BoundedArray([2]u32, 10).init(0);
    while (i < inp.len) : (i += 1) {
        var winners: u256 = 0;
        var p: u5 = 0;
        while (inp[i] != ':') : (i += 1) {}
        i += 2;
        while (inp[i] != '|') : (i += 1) {
            while (inp[i] == ' ') : (i += 1) {}
            const n = try aoc.chompUint(u8, inp, &i);
            winners |= @as(u256, 1) << n;
        }
        i += 2;
        while (true) : (i += 1) {
            while (inp[i] == ' ') : (i += 1) {}
            const n = try aoc.chompUint(u8, inp, &i);
            if (winners & (@as(u256, 1) << n) != 0) {
                p += 1;
            }
            if (inp[i] == '\n') {
                break;
            }
        }
        if (p > 0) {
            p1 += @as(u32, 1) << (p - 1);
        }
        var n: u32 = 1;
        var k: usize = 0;
        for (0..copies.len) |j| {
            var cur = copies.get(j);
            cur[0] -= 1;
            n += cur[1];
            if (cur[0] > 0) {
                copies.set(k, cur);
                k += 1;
            }
        }
        try copies.resize(k);
        p2 += n;
        if (p > 0) {
            try copies.append([2]u32{ p, n });
        }
    }
    return [2]u32{ p1, p2 };
}

fn day04(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day04);
}
