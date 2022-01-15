const std = @import("std");
const aoc = @import("aoc-lib.zig");

pub fn parts(alloc: std.mem.Allocator, inp: []const u8) ![2]usize {
    var i: usize = 0;
    while (inp[i] != '\n') : (i += 1) {}
    var init = inp[0..i];
    i += 2;
    var middleFor = [_]u5{0} ** 676;
    while (i < inp.len) : (i += 8) {
        middleFor[@as(usize, inp[i] - 'A') * 26 + @as(usize, inp[i + 1] - 'A')] = @intCast(u5, inp[i + 6] - 'A');
    }
    var pc = std.AutoHashMap([2]u5, usize).init(alloc);
    defer pc.deinit();
    i = 0;
    while (i < init.len - 1) : (i += 1) {
        var pair = [2]u5{ @intCast(u5, init[i] - 'A'), @intCast(u5, init[i + 1] - 'A') };
        try pc.put(pair, (pc.get(pair) orelse 0) + 1);
    }
    var npc = std.AutoHashMap([2]u5, usize).init(alloc);
    defer npc.deinit();
    var r = [2]usize{ 0, 0 };
    var day: usize = 1;
    while (day <= 40) : (day += 1) {
        var pit = pc.iterator();
        while (pit.next()) |e| {
            var a = e.key_ptr.*[0];
            var b = e.key_ptr.*[1];
            var m = middleFor[@as(usize, a) * 26 + b];
            try npc.put([2]u5{ a, m }, (npc.get([2]u5{ a, m }) orelse 0) + e.value_ptr.*);
            try npc.put([2]u5{ m, b }, (npc.get([2]u5{ m, b }) orelse 0) + e.value_ptr.*);
        }
        std.mem.swap(std.AutoHashMap([2]u5, usize), &pc, &npc);
        npc.clearRetainingCapacity();
        if (day == 10) {
            r[0] = mostMinusLeast(pc, init);
        }
    }
    r[1] = mostMinusLeast(pc, init);
    return r;
}

fn mostMinusLeast(pairCounts: std.AutoHashMap([2]u5, usize), init: []const u8) usize {
    var c: [26]usize = [_]usize{0} ** 26;
    c[init[init.len - 1] - 'A'] += 1;
    var it = pairCounts.iterator();
    while (it.next()) |e| {
        c[e.key_ptr.*[0]] += e.value_ptr.*;
    }
    var min: usize = std.math.maxInt(usize);
    var max: usize = 0;
    for (c) |v| {
        if (v != 0 and min > v) {
            min = v;
        }
        if (max < v) {
            max = v;
        }
    }
    return max - min;
}

test "parts" {
    var t1 = try parts(aoc.talloc, aoc.test1file);
    try aoc.assertEq(@as(usize, 1588), t1[0]);
    var r = try parts(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(usize, 2891), r[0]);
    try aoc.assertEq(@as(usize, 2188189693529), t1[1]);
    try aoc.assertEq(@as(usize, 4607749009683), r[1]);
}

fn day14(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(aoc.halloc, inp);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day14);
}
