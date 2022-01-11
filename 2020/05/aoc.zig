const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    var t1 = aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(t1);
    try aoc.assertEq(@as(usize, 820), part1(t1));
    try aoc.assertEq(@as(usize, 0), part2(aoc.talloc, t1));
    var ti = aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(ti);
    try aoc.assertEq(@as(usize, 947), part1(ti));
    try aoc.assertEq(@as(usize, 636), part2(aoc.talloc, ti));
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
    for (inp) |dir| {
        const s = seat(dir);
        if (s > m) {
            m = s;
        }
    }
    return m;
}

fn part2(alloc: std.mem.Allocator, inp: anytype) usize {
    var plan = std.AutoHashMap(usize, bool).init(alloc);
    defer plan.deinit();
    for (inp) |dir| {
        plan.put(seat(dir), true) catch {};
    }
    var it = plan.iterator();
    while (it.next()) |e| {
        if (plan.contains(e.key_ptr.* - 2) and !plan.contains(e.key_ptr.* - 1)) {
            return e.key_ptr.* - 1;
        }
    }
    return 0;
}

fn day05(inp: []const u8, bench: bool) anyerror!void {
    var plan = aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(plan);
    var p1 = part1(plan);
    var p2 = part2(aoc.halloc, plan);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day05);
}
