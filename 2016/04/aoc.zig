const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var count: [26]usize = .{0} ** 26;
    var n: usize = 0;
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    var l: usize = 0;
    var alpha: [26]u8 = [26]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 };
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            '-' => {},
            'a'...'z' => {
                count[@as(usize, inp[i] - 'a')] += 1;
            },
            '0'...'9' => {
                n = 10 * n + @as(usize, inp[i] & 0xf);
            },
            '[' => {
                i += 1;
                std.mem.sort(u8, &alpha, count, count_sort);
                for (0..5) |j| {
                    if (inp[i + j] - 'a' != alpha[j]) {
                        n = 0;
                        break;
                    }
                }
                p1 += n;
                if (rot(inp[l], n) == 'n' and rot(inp[l + 1], n) == 'o' and rot(inp[l + 2], n) == 'r' and rot(inp[l + 3], n) == 't' and rot(inp[l + 4], n) == 'h') {
                    p2 = n;
                }
                n = 0;
                count = .{0} ** 26;
                i += 6;
                l = i + 1;
                std.debug.assert(inp[i] == '\n');
            },
            else => unreachable,
        }
    }
    return [2]usize{ p1, p2 };
}

fn rot(a: u8, n: usize) u8 {
    return 'a' + ((a - 'a' + @as(u8, @intCast(n % 26))) % 26);
}

fn count_sort(count: [26]usize, a: u8, b: u8) bool {
    return (count[a] == count[b] and a < b) or count[a] > count[b];
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
