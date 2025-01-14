const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: [8]u8,
    p2: usize,
};

fn parts(inp: []const u8) anyerror!Res {
    var s = try std.BoundedArray([4]i32, 400).init(0);
    var b: [4]i32 = [4]i32{
        std.math.maxInt(i32), std.math.minInt(i32), 0, 0,
    };
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 2) {
            i += 10;
            while (inp[i] == ' ') : (i += 1) {}
            const x = try aoc.chompInt(i32, inp, &i);
            i += 2;
            while (inp[i] == ' ') : (i += 1) {}
            const y = try aoc.chompInt(i32, inp, &i);
            i += 12;
            while (inp[i] == ' ') : (i += 1) {}
            const vx = try aoc.chompInt(i32, inp, &i);
            i += 2;
            while (inp[i] == ' ') : (i += 1) {}
            const vy = try aoc.chompInt(i32, inp, &i);
            if (y < b[0]) {
                b[0] = y;
                b[2] = vy;
            }
            if (y > b[1]) {
                b[1] = y;
                b[3] = vy;
            }
            try s.append([4]i32{ x, y, vx, vy });
        }
    }
    var points = s.slice();
    const t = @divTrunc(b[1] - b[0], b[2] - b[3]);
    var sb: [4]i32 = [4]i32{
        std.math.maxInt(i32), std.math.minInt(i32),
        std.math.maxInt(i32), std.math.minInt(i32),
    };
    {
        for (0..points.len) |i| {
            points[i][0] += points[i][2] * t;
            points[i][1] += points[i][3] * t;
            if (points[i][0] < sb[0]) {
                sb[0] = points[i][0];
            }
            if (points[i][0] > sb[1]) {
                sb[1] = points[i][0];
            }
            if (points[i][1] < sb[2]) {
                sb[2] = points[i][1];
            }
            if (points[i][1] > sb[3]) {
                sb[3] = points[i][1];
            }
        }
    }
    var rows: [10]u64 = .{0} ** 10;
    {
        for (0..points.len) |i| {
            const x = points[i][0] - sb[0];
            const y = @as(usize, @intCast(points[i][1] - sb[2]));
            const bit = @as(u64, 1) << @as(u6, @intCast(x));
            rows[y] |= bit;
        }
    }
    var res = Res{ .p1 = .{32} ** 8, .p2 = @as(usize, @intCast(t)) };
    {
        for (0..8) |i| {
            var ch: u64 = 0;
            for (0..rows.len) |j| {
                for (0..6) |_| {
                    ch |= rows[j] & 1;
                    ch <<= 1;
                    rows[j] >>= 1;
                }
                rows[j] >>= 2;
            }
            res.p1[i] = ocr(ch);
        }
    }
    return res;
}

fn ocr(n: u64) u8 {
    return switch (n) {
        0b0011000100101000011000011000011111111000011000011000011000010 => 'A',
        0b0111101000011000001000001000001000001000001000001000010111100 => 'C',
        0b1111111000001000001000001111101000001000001000001000001111110 => 'E',
        0b0111101000011000001000001000001001111000011000011000110111010 => 'G',
        0b1000011000011000011000011111111000011000011000011000011000010 => 'H',
        0b1000011000101001001010001100001100001010001001001000101000010 => 'K',
        0b1000001000001000001000001000001000001000001000001000001111110 => 'L',
        0b1000011100011100011010011010011001011001011000111000111000010 => 'N',
        0b1111101000011000011000011111101001001000101000101000011000010 => 'R',
        0b1111110000010000010000100001000010000100001000001000001111110 => 'Z',
        else => '?',
    };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
