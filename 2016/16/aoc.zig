const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2][17]u8 {
    const l = inp.len - 1; //ignore newline
    var n: u64 = 0;
    var p: u64 = 0;
    var i: usize = 0;
    while (i < l) : (i += 1) {
        p ^= @as(usize, @intFromBool(inp[i] == '1'));
        n ^= p << @as(u6, @intCast(i + 1));
    }
    i = 1;
    while (i <= l) : (i += 1) {
        p ^= @as(usize, @intFromBool(inp[l - i] != '1'));
        n ^= p << @as(u6, @intCast(l + i));
    }
    return [2][17]u8{ calc(n, l, 272), calc(n, l, 35651584) };
}

fn calc(n: u64, l: usize, size: usize) [17]u8 {
    var res: [17]u8 = .{'?'} ** 17;
    var ri: usize = 0;
    const inc: u64 = @as(u64, 1) << @as(u6, @intCast(@ctz(size)));
    var k = inc;
    var pp: u64 = 0;
    while (k <= size) : (k += inc) {
        const d = k / (l + 1);
        const c = (k - d) / (l * 2);
        const r = (k - d) % (l * 2);
        const g = d ^ (d >> 1);
        var p = g ^ @popCount(d & g) & 1;
        p ^= c & l;
        p ^= n >> @as(u6, @intCast(r));
        p &= 1;
        res[ri] = '1' - @as(u8, @intCast(p ^ pp));
        ri += 1;
        pp = p;
    }
    return res;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
