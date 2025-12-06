const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const w = 1 + (std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable);
    const h = inp.len / w - 1;
    var p1: usize = 0;
    var p2: usize = 0;
    var i = h * w;
    while (i < inp.len) {
        const op = inp[i];
        const j = i;
        i += 1;
        skip(inp, &i);
        if (op == '+') {
            p1 += add(inp, j - w * h, 1, w, i - j - 1, h);
            p2 += add(inp, j - w * h, w, 1, h, i - j - 1);
        } else {
            p1 += mul(inp, j - w * h, 1, w, i - j - 1, h);
            p2 += mul(inp, j - w * h, w, 1, h, i - j - 1);
        }
    }
    return [2]usize{ p1, p2 };
}

inline fn skip(inp: []const u8, i: *usize) void {
    while (i.* < inp.len and inp[i.*] <= ' ') : (i.* += 1) {}
}

inline fn add(inp: []const u8, i: usize, di: usize, ni: usize, d: usize, nums: usize) usize {
    var res: usize = 0;
    for (0..nums) |j| {
        var n: usize = 0;
        for (0..d) |k| {
            const ch = inp[i + k * di + j * ni];
            if (ch == ' ') {
                continue;
            }
            n = 10 * n + @as(usize, @intCast(ch & 0xf));
        }
        res += n;
    }
    return res;
}

inline fn mul(inp: []const u8, i: usize, di: usize, ni: usize, d: usize, nums: usize) usize {
    var res: usize = 1;
    for (0..nums) |j| {
        var n: usize = 0;
        for (0..d) |k| {
            const ch = inp[i + k * di + j * ni];
            if (ch == ' ') {
                continue;
            }
            n = 10 * n + @as(usize, @intCast(ch & 0xf));
        }
        res *= n;
    }
    return res;
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
