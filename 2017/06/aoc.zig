const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var bank: [16]u8 = .{0} ** 16;
    var l: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        bank[l] = try aoc.chompUint(u8, inp, &i);
        l += 1;
    }
    var bank1: [16]u8 = undefined;
    std.mem.copyForwards(u8, bank1[0..l], bank[0..l]);
    var bank2: [16]u8 = undefined;
    std.mem.copyForwards(u8, bank2[0..l], bank[0..l]);

    // Floyd's cycle detection
    while (true) {
        realloc(bank1[0..l]);
        realloc(bank2[0..l]);
        realloc(bank2[0..l]);
        if (std.mem.eql(u8, bank1[0..l], bank2[0..l])) {
            break;
        }
    }
    var mu: usize = 0;
    std.mem.copyForwards(u8, bank1[0..l], bank[0..l]);
    while (!std.mem.eql(u8, bank1[0..l], bank2[0..l])) {
        realloc(bank1[0..l]);
        realloc(bank2[0..l]);
        mu += 1;
    }

    var lam: usize = 1;
    std.mem.copyForwards(u8, bank2[0..l], bank1[0..l]);
    realloc(bank2[0..l]);
    while (!std.mem.eql(u8, bank1[0..l], bank2[0..l])) {
        realloc(bank2[0..l]);
        lam += 1;
    }

    return [2]usize{ mu + lam, lam };
}

fn realloc(b: []u8) void {
    var mi: usize = 0;
    var m: u8 = 0;
    for (0..b.len) |i| {
        if (m < b[i]) {
            m = b[i];
            mi = i;
        }
    }
    b[mi] = 0;
    mi += 1;
    if (mi == b.len) {
        mi = 0;
    }
    for (0..@as(usize, m)) |_| {
        b[mi] += 1;
        mi += 1;
        if (mi == b.len) {
            mi = 0;
        }
    }
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
