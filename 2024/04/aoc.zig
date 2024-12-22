const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var w: usize = 0;
    while (inp[w] != '\n') : (w += 1) {}
    w += 1;
    for (0..inp.len) |i| {
        if (inp[i] == 'X') {
            for ([_]usize{ 1, w, w - 1, w + 1 }) |o| {
                if (i + o * 3 < inp.len) {
                    if (inp[i + o * 3] == 'S' and inp[i + o * 2] == 'A' and inp[i + o * 1] == 'M') {
                        p1 += 1;
                    }
                }
                if (i >= o * 3) {
                    if (inp[i - o * 3] == 'S' and inp[i - o * 2] == 'A' and inp[i - o * 1] == 'M') {
                        p1 += 1;
                    }
                }
            }
        } else if (inp[i] == 'A') {
            if (i >= w + 1 and i + w + 1 < inp.len) {
                if ((inp[i - w - 1] == 'M' and inp[i + w + 1] == 'S' or
                    inp[i - w - 1] == 'S' and inp[i + w + 1] == 'M') and
                    (inp[i - w + 1] == 'M' and inp[i + w - 1] == 'S' or
                    inp[i - w + 1] == 'S' and inp[i + w - 1] == 'M'))
                {
                    p2 += 1;
                }
            }
        }
    }
    return [2]usize{ p1, p2 };
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
