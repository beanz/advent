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
    const test1 = try aoc.readLines(@embedFile("test1.txt"));
    var r: usize = 2;
    assertEq(r, part1(test1));
    assertEq(r, part2(test1));
}

fn seat(dir: []const u8) usize {
    var s: usize = 0;
    var sm: usize = 1024;
    for (dir) |ch| {
        switch (ch) {
            'F', 'L' => {
                sm /= 2;
            },
            'B', 'R' => {
                sm /= 2;
                s += sm;
            },
            else => {},
        }
    }
    return s;
}

fn part1(inp: anytype) usize {
    var m: usize = 0;
    for (inp.items) |dir| {
        const s = seat(dir);
        if (s > m) {
            m = s;
        }
    }
    return m;
}

fn part2(inp: anytype) usize {
    var plan = std.AutoHashMap(usize, bool).init(alloc);
    defer plan.deinit();
    for (inp.items) |dir| {
        plan.put(seat(dir), true) catch {};
    }
    var it = plan.iterator();
    while (it.next()) |e| {
        if (aoc.exists(plan, e.key - 2) and !aoc.exists(plan, e.key - 1)) {
            return e.key - 1;
        }
    }
    return 0;
}

pub fn main() anyerror!void {
    var plan = try aoc.readLines(input);
    //try out.print("{}\n", .{report.items.len});
    try out.print("Part1: {}\n", .{part1(plan)});
    try out.print("Part2: {}\n", .{part2(plan)});
}
