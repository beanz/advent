const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

inline fn initRope(comptime l: usize) [l]u8 {
    var r: [l]u8 = undefined;
    inline for (0..l) |i| {
        r[i] = @as(u8, @intCast(i));
    }
    return r;
}

const SIZE = 256;

const Res = struct {
    p1: usize,
    p2: [32]u8,
};

fn parts(inp: []const u8) anyerror!Res {
    var res = Res{ .p1 = 0, .p2 = .{32} ** 32 };
    var rope: [SIZE]u8 = initRope(SIZE);
    {
        var cur: usize = 0;
        var skip: usize = 0;
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const n = try aoc.chompUint(usize, inp, &i);
            std.mem.rotate(u8, &rope, cur);
            std.mem.reverse(u8, rope[0..n]);
            std.mem.rotate(u8, &rope, SIZE - cur);
            cur = (cur + n + skip) & 0xff;
            skip += 1;
        }
        res.p1 = @as(usize, @intCast(rope[0])) * @as(usize, @intCast(rope[1]));
    }
    var rope2: [SIZE]u8 = initRope(SIZE);
    {
        var cur: usize = 0;
        var skip: usize = 0;
        for (0..64) |_| {
            var i: usize = 0;
            while (i < inp.len - 1) : (i += 1) {
                const n = @as(usize, @intCast(inp[i]));
                std.mem.rotate(u8, &rope2, cur);
                std.mem.reverse(u8, rope2[0..n]);
                std.mem.rotate(u8, &rope2, SIZE - cur);
                cur = (cur + n + skip) & 0xff;
                skip += 1;
            }
            for ([5]usize{ 17, 31, 73, 47, 23 }) |n| {
                std.mem.rotate(u8, &rope2, cur);
                std.mem.reverse(u8, rope2[0..n]);
                std.mem.rotate(u8, &rope2, SIZE - cur);
                cur = (cur + n + skip) & 0xff;
                skip += 1;
            }
        }
    }
    {
        const HEX = [16]u8{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
        for (0..16) |i| {
            var sum: u8 = 0;
            for (0..16) |j| {
                sum ^= rope2[i * 16 + j];
            }
            const s = @as(usize, @intCast(sum));
            res.p2[i * 2] = HEX[s >> 4];
            res.p2[1 + i * 2] = HEX[s & 0xf];
        }
    }

    return res;
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
