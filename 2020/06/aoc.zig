const std = @import("std");
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const test1 = try aoc.readChunks(@embedFile("test1.txt"));
    var r: usize = 11;
    assertEq(r, part1(test1));
    r = 6;
    assertEq(r, part2(test1));

    const inp = try aoc.readChunks(input);
    r = 6506;
    assertEq(r, part1(inp));
    r = 3243;
    assertEq(r, part2(inp));
}

fn part1(inp: anytype) usize {
    var c: usize = 0;
    for (inp.items) |ent| {
        var m = std.AutoHashMap(u8, usize).init(alloc);
        defer m.deinit();
        var pit = std.mem.split(ent, "\n");
        while (pit.next()) |ans| {
            for (ans) |ch| {
                aoc.minc(&m, ch);
            }
        }
        var gc: usize = 0;
        var mit = m.iterator();
        while (mit.next()) |ch| {
            gc += 1;
        }
        c += gc;
    }
    return c;
}

fn part2(inp: anytype) usize {
    var c: usize = 0;
    for (inp.items) |ent| {
        var m = std.AutoHashMap(u8, usize).init(alloc);
        defer m.deinit();
        var people: usize = 0;
        var pit = std.mem.split(ent, "\n");
        while (pit.next()) |ans| {
            people += 1;
            for (ans) |ch| {
                aoc.minc(&m, ch);
            }
        }
        var gc: usize = 0;
        var mit = m.iterator();
        while (mit.next()) |ch| {
            if (ch.value == people) {
                gc += 1;
            }
        }
        c += gc;
    }
    return c;
}

pub fn main() anyerror!void {
    var dec = try aoc.readChunks(input);
    try out.print("Part1: {}\n", .{part1(dec)});
    try out.print("Part2: {}\n", .{part2(dec)});
}
