const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: usize,
    p2: [5]u8,
};

fn parts(inp: []const u8) anyerror!Res {
    const w: usize = 25;
    const h: usize = 6;
    const l = w * h;
    var p1: usize = 0;
    {
        var min: usize = std.math.maxInt(usize);
        var i: usize = 0;
        while (i < inp.len - 1) : (i += l) {
            var c: [3]usize = .{0} ** 3;
            for (0..l) |j| {
                c[@as(usize, @intCast(inp[i + j] & 3))] += 1;
            }
            if (c[0] < min) {
                min = c[0];
                p1 = c[1] * c[2];
            }
        }
    }

    var p2: [5]u8 = .{32} ** 5;
    {
        for (0..5) |i| {
            var ch: u64 = 0;
            const o: usize = w - 5 * (4 - i);
            for (0..6) |y| {
                for (0..5) |j| {
                    const x: usize = o - (5 - j);
                    const set = bit(inp, x, y, w, l);
                    ch = (ch << 1) + @intFromBool(set);
                }
            }
            p2[i] = aoc.ocr(ch);
        }
    }
    return Res{ .p1 = p1, .p2 = p2 };
}

inline fn bit(inp: []const u8, x: usize, y: usize, w: usize, l: usize) bool {
    var i = y * w + x;
    while (i < inp.len - 1) : (i += l) {
        switch (inp[i]) {
            '0' => return false,
            '1' => return true,
            else => {},
        }
    }
    unreachable;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {s}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
