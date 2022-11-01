const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn part1(in: [][]const u8) u64 {
    const dt = std.fmt.parseUnsigned(u64, in[0], 10) catch unreachable;
    var min: u64 = std.math.maxInt(u64);
    var mbus: u64 = undefined;
    var bit = std.mem.split(u8, in[1], ",");
    while (bit.next()) |ts| {
        if (ts[0] == 'x') {
            continue;
        }
        const t = std.fmt.parseUnsigned(u64, ts, 10) catch unreachable;
        const m = t - (dt % t);
        if (m < min) {
            min = m;
            mbus = t;
        }
    }
    return min * mbus;
}

fn egcd(a: i64, b: i64, x: *i64, y: *i64) i64 {
    if (a == 0) {
        x.* = 0;
        y.* = 1;
        return b;
    } else {
        const g = egcd(@mod(b, a), a, x, y);
        const t = x.*;
        x.* = y.* - @divFloor(b, a) * t;
        y.* = t;
        return g;
    }
}

fn chinese(la: std.ArrayList(i64), ln: std.ArrayList(i64)) i64 {
    var p: i64 = 1;
    for (ln.items) |n| {
        p *= n;
    }
    var x: i64 = 0;
    var j: i64 = undefined; // place holder for egcd result we don't need
    for (ln.items) |n, i| {
        const a = la.items[i];
        const q = @divExact(p, n);
        var y: i64 = undefined;
        const z = egcd(n, q, &j, &y);
        //warn("q={} x={} y={} z={}\n", .{ q, j, y, z });
        if (z != 1) {
            std.debug.print("{} is not coprime\n", .{n});
            return 0;
        }
        x += a * y * q;
        x = @mod(x, p);
        //warn("x={}\n", .{x});
    }
    return x;
}

fn part2(alloc: std.mem.Allocator, in: [][]const u8) i64 {
    var bit = std.mem.split(u8, in[1], ",");
    var a = std.ArrayList(i64).init(alloc);
    defer a.deinit();
    var n = std.ArrayList(i64).init(alloc);
    defer n.deinit();
    var i: i64 = 0;
    while (bit.next()) |ts| {
        defer {
            i += 1;
        }
        if (ts[0] == 'x') {
            continue;
        }
        const t = std.fmt.parseUnsigned(i64, ts, 10) catch unreachable;
        //warn("Adding pair {} and {}\n", .{ t - i, t });
        a.append(t - i) catch unreachable;
        n.append(t) catch unreachable;
    }
    return chinese(a, n);
}

test "examples" {
    const test1 = aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = aoc.readLines(aoc.talloc, aoc.test2file);
    defer aoc.talloc.free(test2);
    const test3 = aoc.readLines(aoc.talloc, aoc.test3file);
    defer aoc.talloc.free(test3);
    const test4 = aoc.readLines(aoc.talloc, aoc.test4file);
    defer aoc.talloc.free(test4);
    const test5 = aoc.readLines(aoc.talloc, aoc.test5file);
    defer aoc.talloc.free(test5);
    const test6 = aoc.readLines(aoc.talloc, aoc.test6file);
    defer aoc.talloc.free(test6);
    const inp = aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(u64, 295), part1(test1));
    try aoc.assertEq(@as(u64, 130), part1(test2));
    try aoc.assertEq(@as(u64, 295), part1(test3));
    try aoc.assertEq(@as(u64, 295), part1(test4));
    try aoc.assertEq(@as(u64, 295), part1(test5));
    try aoc.assertEq(@as(u64, 47), part1(test6));
    try aoc.assertEq(@as(u64, 3035), part1(inp));

    try aoc.assertEq(@as(i64, 1068781), part2(aoc.talloc, test1));
    try aoc.assertEq(@as(i64, 3417), part2(aoc.talloc, test2));
    try aoc.assertEq(@as(i64, 754018), part2(aoc.talloc, test3));
    try aoc.assertEq(@as(i64, 779210), part2(aoc.talloc, test4));
    try aoc.assertEq(@as(i64, 1261476), part2(aoc.talloc, test5));
    try aoc.assertEq(@as(i64, 1202161486), part2(aoc.talloc, test6));
    try aoc.assertEq(@as(i64, 725169163285238), part2(aoc.talloc, inp));
}

fn day13(inp: []const u8, bench: bool) anyerror!void {
    const lines = aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var p1 = part1(lines);
    var p2 = part2(aoc.halloc, lines);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day13);
}
