const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2 = std.AutoHashMap(usize, usize).init(aoc.halloc);
    defer p2.deinit();
    try p2.ensureTotalCapacity(42000);
    var m: usize = 0;
    var i: usize = 0;
    var seen: [1048576]u16 = .{0} ** 1048576;
    var seen_val: u16 = 1;
    while (i < inp.len) : (i += 1) {
        var n = try aoc.chompUint(u24, inp, &i);
        var prev: i8 = @intCast(n % 10);
        var k: usize = 0;
        for (0..4) |_| {
            n ^= n << 6;
            n ^= n >> 5;
            n ^= n << 11;
            const price: usize = @intCast(n % 10);
            const ip: i8 = @intCast(price);
            const diff: usize = @intCast((ip - prev) & 0x1f);
            prev = ip;
            k = ((k << 5) + diff) & 0xfffff;
        }
        for (4..2000) |_| {
            n ^= n << 6;
            n ^= n >> 5;
            n ^= n << 11;
            var price: usize = @intCast(n % 10);
            const ip: i8 = @intCast(price);
            const diff: usize = @intCast((ip - prev) & 0x1f);
            prev = ip;
            k = ((k << 5) + diff) & 0xfffff;
            if (seen[k] == seen_val) {
                continue;
            }
            seen[k] = seen_val;
            if (p2.getPtr(k)) |e| {
                e.* += price;
                price = e.*;
            } else {
                try p2.put(k, price);
            }
            if (m < price) {
                m = price;
            }
        }
        seen_val += 1;
        p1 += n;
    }
    return [2]usize{ p1, m };
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
