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
        p2r[10 - j - 1] = ocr(n);
    }
    return Res{ .p1 = p1, .p2 = p2r };
}

fn ocr(n: u64) u8 {
    return switch (n) {
        0b011001001010010111101001010010 => 'A',
        0b111001001011100100101001011100 => 'B',
        0b011001001010000100001001001100 => 'C',
        0b111001001010010100101001011100 => 'D',
        0b111101000011100100001000011110 => 'E',
        0b111101000011100100001000010000 => 'F',
        0b011001001010000101101001001110 => 'G',
        0b100101001011110100101001010010 => 'H',
        0b011100010000100001000010001110 => 'I',
        0b001100001000010000101001001100 => 'J',
        0b100101010011000101001010010010 => 'K',
        0b100001000010000100001000011110 => 'L',
        0b011001001010010100101001001100 => 'O',
        0b111001001010010111001000010000 => 'P',
        0b111001001010010111001010010010 => 'R',
        0b011101000010000011000001011100 => 'S',
        0b011100010000100001000010000100 => 'T',
        0b100101001010010100101001001100 => 'U',
        0b100011000101010001000010000100 => 'Y',
        0b111100001000100010001000011110 => 'Z',
        else => '?',
    };
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
