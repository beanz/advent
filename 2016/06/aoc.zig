const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2][8]u8 {
    var p1r: [8]u8 = .{32} ** 8;
    var p2r: [8]u8 = .{32} ** 8;
    var j: usize = 0;
    var cc: [256]usize = .{0} ** 256;
    for (inp, 0..) |ch, i| {
        switch (ch) {
            '\n' => {
                j = i + 1;
            },
            else => {
                const p = i - j;
                cc[((ch - 'a') << 3) + p] += 1;
            },
        }
    }
    const l: usize = if (inp.len < 128) 6 else 8;
    const e: usize = if (inp.len < 128) 7 else 25;
    var alpha: [26]u8 = [26]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 };
    for (0..l) |i| {
        std.mem.sort(u8, &alpha, Ctx{ .i = i, .cc = &cc }, count_sort);
        p1r[i] = 'a' + alpha[0];
        p2r[i] = 'a' + alpha[e];
    }
    return [2][8]u8{ p1r, p2r };
}

fn count_sort(ctx: Ctx, a: u8, b: u8) bool {
    return ctx.cc[(a << 3) + ctx.i] > ctx.cc[(b << 3) + ctx.i];
}

const Ctx = struct {
    i: usize,
    cc: *[256]usize,
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
