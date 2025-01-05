const std = @import("std");
const aoc = @import("aoc-lib.zig");
const Md5 = std.crypto.hash.Md5;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const CHR: *const [16]u8 = "0123456789abcdef";

fn parts(inp: []const u8) anyerror![2][8]u8 {
    var p1r: [8]u8 = .{32} ** 8;
    var p2r: [8]u8 = .{32} ** 8;
    var b: [40]u8 = .{0} ** 40;
    var h: [Md5.digest_length]u8 = .{1} ** Md5.digest_length;
    std.mem.copyForwards(u8, &b, inp);
    var n = try aoc.NumStr.init(aoc.halloc, &b, inp.len - 1);
    var i: usize = 0;
    var done: [8]bool = .{false} ** 8;
    var p2c: usize = 0;
    while (true) {
        Md5.hash(n.bytes(), &h, .{});
        if (h[0] == 0 and h[1] == 0 and h[2] & 0xf0 == 0) {
            const sixth = h[2] & 0xf;
            const seventh = (h[3] & 0xf0) >> 4;
            if (i < 8) {
                p1r[i] = CHR[sixth];
                i += 1;
            }
            if (sixth < 8 and !done[sixth]) {
                p2r[sixth] = CHR[seventh];
                done[sixth] = true;
                p2c += 1;
            }
            if (i == 8 and p2c == 8) {
                break;
            }
        }
        n.inc();
    }
    return [2][8]u8{ p1r, p2r };
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
