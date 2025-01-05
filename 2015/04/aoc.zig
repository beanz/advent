const std = @import("std");
const aoc = @import("aoc-lib.zig");
const Md5 = std.crypto.hash.Md5;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var b: [40]u8 = .{0} ** 40;
    var h: [Md5.digest_length]u8 = .{1} ** Md5.digest_length;
    std.mem.copyForwards(u8, &b, inp);
    var n = try aoc.NumStr.init(aoc.halloc, &b, inp.len - 1);
    while (true) {
        Md5.hash(n.bytes(), &h, .{});
        if (h[0] == 0 and h[1] == 0 and h[2] & 0xf0 == 0) {
            break;
        }
        n.inc();
    }
    const p1 = n.count();
    n = try aoc.NumStr.init(aoc.halloc, &b, inp.len - 1);
    while (true) {
        Md5.hash(n.bytes(), &h, .{});
        if (h[0] == 0 and h[1] == 0 and h[2] == 0) {
            break;
        }
        n.inc();
    }
    const p2 = n.count();
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
