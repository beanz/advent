const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const REP = [4]isize{ 0, 1, 0, -1 };

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    {
        var cur: [650]u8 = undefined;
        for (0..650) |i| {
            cur[i] = inp[i] & 0xf;
        }
        var next: [650]u8 = undefined;
        for (0..100) |_| {
            for (1..651) |i| {
                var n: isize = 0;
                for (0..650) |j| {
                    const di = (1 + j) / i;
                    const m = REP[di & 0x3];
                    n += @as(isize, @intCast(cur[j])) * m;
                }
                if (n < 0) {
                    n *= -1;
                }
                n = @rem(n, 10);
                next[i - 1] = @intCast(n);
            }
            std.mem.swap([650]u8, &cur, &next);
        }
        for (0..8) |i| {
            p1 = p1 * 10 + @as(usize, @intCast(cur[i]));
        }
    }
    var p2: usize = 0;
    {
        var offset: usize = 0;
        for (0..7) |i| {
            offset = offset * 10 + @as(usize, @intCast(inp[i] & 0xf));
        }
        var s = try std.BoundedArray(i32, 800000).init(0);
        for (offset..650 * 10000) |i| {
            try s.append(@intCast(inp[i % 650] & 0xf));
        }
        var cur = s.slice();
        for (0..100) |_| {
            var sum: isize = 0;
            var i: usize = cur.len;
            while (i > 0) : (i -= 1) {
                sum += @intCast(cur[i - 1]);
                cur[i - 1] = @intCast(@rem(if (sum < 0) -sum else sum, 10));
            }
        }

        for (0..8) |i| {
            p2 = p2 * 10 + @as(usize, @intCast(cur[i]));
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
