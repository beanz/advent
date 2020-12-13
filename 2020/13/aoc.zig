const std = @import("std");
const Args = std.process.args;
const warn = std.debug.warn;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const test2file = @embedFile("test2.txt");
const test3file = @embedFile("test3.txt");
const test4file = @embedFile("test4.txt");
const test5file = @embedFile("test5.txt");
const test6file = @embedFile("test6.txt");
const stdout = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

fn part1(in: std.ArrayListAligned([]const u8, null)) u64 {
    const dt = std.fmt.parseUnsigned(u64, in.items[0], 10) catch unreachable;
    var min: u64 = std.math.maxInt(u64);
    var mbus: u64 = undefined;
    var bit = std.mem.split(in.items[1], ",");
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

fn chinese(la: std.ArrayListAligned(i64, null), ln: std.ArrayListAligned(i64, null)) i64 {
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
            warn("{} is not coprime\n", .{n});
            return 0;
        }
        x += a * y * q;
        x = @mod(x, p);
        //warn("x={}\n", .{x});
    }
    return x;
}

fn part2(in: std.ArrayListAligned([]const u8, null)) i64 {
    var bit = std.mem.split(in.items[1], ",");
    var a = std.ArrayList(i64).init(alloc);
    var n = std.ArrayList(i64).init(alloc);
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
    const test1 = try aoc.readLines(test1file);
    const test2 = try aoc.readLines(test2file);
    const test3 = try aoc.readLines(test3file);
    const test4 = try aoc.readLines(test4file);
    const test5 = try aoc.readLines(test5file);
    const test6 = try aoc.readLines(test6file);
    const inp = try aoc.readLines(input);

    var r: u64 = 295;
    assertEq(r, part1(test1));
    r = 130;
    assertEq(r, part1(test2));
    r = 295;
    assertEq(r, part1(test3));
    assertEq(r, part1(test4));
    assertEq(r, part1(test5));
    r = 47;
    assertEq(r, part1(test6));
    r = 3035;
    assertEq(r, part1(inp));

    var r2: i64 = 1068781;
    assertEq(r2, part2(test1));
    r2 = 3417;
    assertEq(r2, part2(test2));
    r2 = 754018;
    assertEq(r2, part2(test3));
    r2 = 779210;
    assertEq(r2, part2(test4));
    r2 = 1261476;
    assertEq(r2, part2(test5));
    r2 = 1202161486;
    assertEq(r2, part2(test6));
    r2 = 725169163285238;
    assertEq(r2, part2(inp));
}

pub fn main() anyerror!void {
    var args = Args();
    const arg0 = args.next(alloc).?;
    var lines: std.ArrayListAligned([]const u8, null) = undefined;
    if (args.next(alloc)) |_| {
        lines = try aoc.readLines(test1file);
    } else {
        lines = try aoc.readLines(input);
    }
    try stdout.print("Part1: {}\n", .{part1(lines)});
    try stdout.print("Part2: {}\n", .{part2(lines)});
}
