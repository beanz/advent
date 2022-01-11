const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    const test1 = aoc.readChunks(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    try aoc.assertEq(@as(usize, 11), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 6), part2(aoc.talloc, test1));

    const inp = aoc.readChunks(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);
    try aoc.assertEq(@as(usize, 6506), part1(aoc.talloc, inp));
    try aoc.assertEq(@as(usize, 3243), part2(aoc.talloc, inp));
}

fn part1(alloc: std.mem.Allocator, inp: anytype) usize {
    var c: usize = 0;
    for (inp) |ent| {
        var m = std.AutoHashMap(u8, usize).init(alloc);
        defer m.deinit();
        var pit = std.mem.split(u8, ent, "\n");
        while (pit.next()) |ans| {
            for (ans) |ch| {
                aoc.minc(&m, ch);
            }
        }
        var gc: usize = 0;
        var mit = m.iterator();
        while (mit.next()) |_| {
            gc += 1;
        }
        c += gc;
    }
    return c;
}

fn part2(alloc: std.mem.Allocator, inp: anytype) usize {
    var c: usize = 0;
    for (inp) |ent| {
        var m = std.AutoHashMap(u8, usize).init(alloc);
        defer m.deinit();
        var people: usize = 0;
        var pit = std.mem.split(u8, ent, "\n");
        while (pit.next()) |ans| {
            people += 1;
            for (ans) |ch| {
                aoc.minc(&m, ch);
            }
        }
        var gc: usize = 0;
        var mit = m.iterator();
        while (mit.next()) |ch| {
            if (ch.value_ptr.* == people) {
                gc += 1;
            }
        }
        c += gc;
    }
    return c;
}

fn day06(inp: []const u8, bench: bool) anyerror!void {
    var dec = aoc.readChunks(aoc.halloc, inp);
    defer aoc.halloc.free(dec);
    var p1 = part1(aoc.halloc, dec);
    var p2 = part2(aoc.halloc, dec);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day06);
}
