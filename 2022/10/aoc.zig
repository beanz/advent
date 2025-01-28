const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: usize,
    p2: [8]u8,
};

fn parts(inp: []const u8) anyerror!Res {
    var inc: [512]i8 = .{0} ** 512;
    var cycle: usize = 0;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            cycle += 1;
            if (inp[i] == 'a') {
                i += 5;
                const n = try aoc.chompInt(i16, inp, &i);
                inc[cycle] = @intCast(n);
                cycle += 1;
            } else {
                i += 4;
            }
        }
    }
    const num = cycle;
    var p2: [6]u64 = .{0} ** 6;
    var p1: usize = 0;
    {
        var x: i8 = 1;
        var y: usize = 0;
        var b: usize = 0;
        var j: i8 = 0;
        var k: usize = 0;
        for (0..240) |i| {
            if (j - 1 <= x and x <= j + 1) {
                p2[y] |= @as(u64, 1) << @as(u6, @intCast(b));
            }
            j += 1;
            b += 1;
            if (j == 20) {
                p1 += (i + 1) * @as(usize, @intCast(x));
            }
            if (j == 40) {
                j = 0;
                y += 1;
                b = 0;
            }
            x += inc[k];
            k += 1;
            if (k == num) {
                k = 0;
            }
        }
    }
    var p2r: [8]u8 = .{32} ** 8;
    {
        for (0..8) |i| {
            var ch: u64 = 0;
            for (0..6) |y| {
                for (0..5) |_| {
                    ch = (ch << 1) | (p2[y] & 0x1);
                    p2[y] >>= 1;
                }
            }
            p2r[i] = aoc.ocr(ch);
        }
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
