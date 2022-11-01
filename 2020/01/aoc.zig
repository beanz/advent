const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    var report = try aoc.Ints(aoc.talloc, u16, aoc.test1file);
    defer aoc.talloc.free(report);
    var p = try parts(aoc.talloc, report);
    try aoc.assertEq(@as(u64, 514579), p[0]);
    try aoc.assertEq(@as(u64, 241861950), p[1]);
    var report2 = try aoc.Ints(aoc.talloc, u16, aoc.inputfile);
    defer aoc.talloc.free(report2);
    var pi = try parts(aoc.talloc, report2);
    try aoc.assertEq(@as(usize, 41979), pi[0]);
    try aoc.assertEq(@as(usize, 193416912), pi[1]);
}

fn parts(alloc: std.mem.Allocator, exp: []const u16) anyerror![2]u64 {
    var products = std.AutoHashMap(u16, u64).init(alloc);
    defer products.deinit();
    var seen = std.AutoHashMap(u16, bool).init(alloc);
    defer seen.deinit();
    var p1: u64 = 0;
    for (exp) |n| {
        var rem = 2020 - n;
        if (seen.contains(rem)) {
            p1 = @as(u64, n) * rem;
        }
        var it = seen.iterator();
        while (it.next()) |e| {
            try products.put(n + e.key_ptr.*, n * @as(u64, e.key_ptr.*));
        }
        try seen.put(n, true);
    }
    for (exp) |n| {
        if (n > 2020) {
            continue;
        }
        var rem = 2020 - n;
        if (products.get(rem)) |p| {
            return [2]u64{ p1, n * p };
        }
    }
    unreachable;
}

fn day01(inp: []const u8, bench: bool) anyerror!void {
    var report = try aoc.Ints(aoc.halloc, u16, inp);
    defer aoc.halloc.free(report);
    var p = try parts(aoc.halloc, report);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day01);
}
