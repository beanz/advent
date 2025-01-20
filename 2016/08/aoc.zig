const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: usize,
    p2: [10]u8,
};

fn parts(inp: []const u8) anyerror!Res {
    var p2r: [10]u8 = .{63} ** 10;
    var m: [6]u64 = .{0} ** 6;
    const dw: usize = if (inp.len < 100) 7 else 50;
    const dh: usize = if (inp.len < 100) 3 else 6;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        if (inp[i + 1] == 'e') {
            i += 5;
            const w = try aoc.chompUint(usize, inp, &i);
            i += 1;
            const h = try aoc.chompUint(usize, inp, &i);
            var bits: u64 = 0;
            for (0..w) |j| {
                const b: u64 = @as(u64, 1) << @as(u6, @intCast(dw - j - 1));
                bits |= b;
            }
            for (0..h) |j| {
                m[j] |= bits;
            }
        } else if (inp[i + 7] == 'c') {
            i += 16;
            const x = try aoc.chompUint(usize, inp, &i);
            i += 4;
            const n = try aoc.chompUint(usize, inp, &i);
            const set: u64 = @as(u64, 1) << @as(u6, @intCast(dw - x - 1));
            const reset: u64 = ((@as(u64, 1) << @as(u6, @intCast(dw))) - 1) ^ set;
            for (0..n) |_| {
                const bottom = m[dh - 1] & set != 0;
                for (1..dh) |y| {
                    if (m[dh - y - 1] & set != 0) {
                        m[dh - y] |= set;
                    } else {
                        m[dh - y] &= reset;
                    }
                }
                if (bottom) {
                    m[0] |= set;
                } else {
                    m[0] &= reset;
                }
            }
        } else {
            i += 13;
            const y = try aoc.chompUint(usize, inp, &i);
            i += 4;
            const n = try aoc.chompUint(usize, inp, &i);
            for (0..n) |_| {
                const b = (m[y] & 1) << @as(u6, @intCast(dw - 1));
                m[y] >>= 1;
                m[y] |= b;
            }
        }
    }
    var p1: usize = 0;
    for (0..dh) |j| {
        p1 += @popCount(m[j]);
    }
    if (inp.len < 100) {
        return Res{ .p1 = p1, .p2 = p2r };
    }
    for (0..10) |j| {
        var n: u64 = 0;
        for (0..dh) |k| {
            n = (n << 5) | (m[k] & 0x1f);
            m[k] >>= 5;
        }
        p2r[10 - j - 1] = aoc.ocr(n);
    }
    return Res{ .p1 = p1, .p2 = p2r };
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
