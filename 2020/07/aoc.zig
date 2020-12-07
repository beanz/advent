const std = @import("std");
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const test1 = try aoc.readLines(test1file);
    const test2 = try aoc.readLines(@embedFile("test2.txt"));
    const inp = try aoc.readLines(input);

    var r: usize = 4;
    assertEq(r, part1(test1));
    r = 0;
    assertEq(r, part1(test2));

    r = 112;
    assertEq(r, part1(inp));

    r = 32;
    assertEq(r, part2(test1));
    r = 126;
    assertEq(r, part2(test2));
    r = 6260;
    assertEq(r, part2(inp));
}

fn traverse1(m: std.StringHashMap(ArrayList([]const u8)), bag: []const u8, seen: *std.StringHashMap(bool)) void {
    if (!m.contains(bag)) {
        return;
    }
    for (m.get(bag).?.items) |outer| {
        _ = seen.getOrPutValue(outer, true) catch unreachable;
        traverse1(m, outer, seen);
    }
}

fn part1(inp: anytype) usize {
    var c: usize = 0;
    var map = std.StringHashMap(ArrayList([]const u8)).init(alloc);
    for (inp.items) |line| {
        var lit = std.mem.split(line, " bags contain ");
        const bag = lit.next().?;
        const spec = lit.next().?;
        if (spec[0] == 'n' and spec[1] == 'o' and spec[2] == ' ') {
            continue;
        }
        var sit = std.mem.split(spec, ", ");
        while (sit.next()) |bags| {
            var bit = std.mem.split(bags, " ");
            const ns = bit.next().?;
            const n = std.fmt.parseUnsigned(usize, ns, 10);
            const b1 = bit.next().?;
            const b2 = bit.next().?;
            var innerBag = alloc.alloc(u8, b1.len + b2.len + 1) catch unreachable;
            std.mem.copy(u8, innerBag[0..], b1);
            innerBag[b1.len] = ' ';
            std.mem.copy(u8, innerBag[b1.len + 1 ..], b2);
            const kv = map.getOrPutValue(innerBag, ArrayList([]const u8).init(alloc)) catch unreachable;
            kv.value.append(bag) catch unreachable;
        }
    }
    var seen = std.StringHashMap(bool).init(alloc);
    traverse1(map, "shiny gold", &seen);
    return seen.count();
}

const BS = struct {
    bag: []const u8, n: usize
};

fn traverse2(m: std.StringHashMap(ArrayList(BS)), bag: []const u8) usize {
    var c: usize = 1;
    if (!m.contains(bag)) {
        return 1;
    }
    for (m.get(bag).?.items) |bc| {
        c += bc.n * traverse2(m, bc.bag);
    }
    return c;
}

fn part2(inp: anytype) usize {
    var c: usize = 0;
    var map = std.StringHashMap(ArrayList(BS)).init(alloc);
    for (inp.items) |line| {
        var lit = std.mem.split(line, " bags contain ");
        const bag = lit.next().?;
        const spec = lit.next().?;
        if (spec[0] == 'n' and spec[1] == 'o' and spec[2] == ' ') {
            continue;
        }
        var sit = std.mem.split(spec, ", ");
        while (sit.next()) |bags| {
            var bit = std.mem.split(bags, " ");
            const ns = bit.next().?;
            const n = std.fmt.parseUnsigned(usize, ns, 10) catch unreachable;
            const b1 = bit.next().?;
            const b2 = bit.next().?;
            var innerBag = alloc.alloc(u8, b1.len + b2.len + 1) catch unreachable;
            std.mem.copy(u8, innerBag[0..], b1);
            innerBag[b1.len] = ' ';
            std.mem.copy(u8, innerBag[b1.len + 1 ..], b2);
            const kv = map.getOrPutValue(bag, ArrayList(BS).init(alloc)) catch unreachable;
            var b = BS{ .bag = innerBag, .n = n };
            kv.value.append(b) catch unreachable;
        }
    }
    return traverse2(map, "shiny gold") - 1;
}

pub fn main() anyerror!void {
    var spec = try aoc.readLines(input);
    try out.print("Part1: {}\n", .{part1(spec)});
    try out.print("Part2: {}\n", .{part2(spec)});
}
