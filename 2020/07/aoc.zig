const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    const test1 = aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = aoc.readLines(aoc.talloc, aoc.test2file);
    defer aoc.talloc.free(test2);
    const inp = aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(usize, 4), try part1(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 0), try part1(aoc.talloc, test2));
    try aoc.assertEq(@as(usize, 112), try part1(aoc.talloc, inp));

    try aoc.assertEq(@as(usize, 32), try part2(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 126), try part2(aoc.talloc, test2));
    try aoc.assertEq(@as(usize, 6260), try part2(aoc.talloc, inp));
}

fn traverse1(m: std.StringHashMap(std.ArrayList([]const u8)), bag: []const u8, seen: *std.StringHashMap(bool)) void {
    if (!m.contains(bag)) {
        return;
    }
    for (m.get(bag).?.items) |outer| {
        _ = seen.getOrPutValue(outer, true) catch unreachable;
        traverse1(m, outer, seen);
    }
}

fn part1(palloc: std.mem.Allocator, inp: anytype) !usize {
    var arena = std.heap.ArenaAllocator.init(palloc);
    defer arena.deinit();
    const alloc = arena.allocator();
    var map = std.StringHashMap(std.ArrayList([]const u8)).init(alloc);
    for (inp) |line| {
        var lit = std.mem.split(u8, line, " bags contain ");
        const bag = lit.next().?;
        const spec = lit.next().?;
        if (spec[0] == 'n' and spec[1] == 'o' and spec[2] == ' ') {
            continue;
        }
        var sit = std.mem.split(u8, spec, ", ");
        while (sit.next()) |bags| {
            var bit = std.mem.split(u8, bags, " ");
            const ns = bit.next().?;
            _ = std.fmt.parseUnsigned(usize, ns, 10) catch unreachable;
            const b1 = bit.next().?;
            const b2 = bit.next().?;
            var innerBag = alloc.alloc(u8, b1.len + b2.len + 1) catch unreachable;
            std.mem.copy(u8, innerBag[0..], b1);
            innerBag[b1.len] = ' ';
            std.mem.copy(u8, innerBag[b1.len + 1 ..], b2);
            const kv = map.getOrPutValue(innerBag, std.ArrayList([]const u8).init(alloc)) catch unreachable;
            kv.value_ptr.append(bag) catch unreachable;
        }
    }
    var seen = std.StringHashMap(bool).init(alloc);
    defer seen.deinit();
    traverse1(map, "shiny gold", &seen);
    return seen.count();
}

const BS = struct { bag: []const u8, n: usize };

fn traverse2(m: std.StringHashMap(std.ArrayList(*BS)), bag: []const u8) usize {
    var c: usize = 1;
    if (!m.contains(bag)) {
        return 1;
    }
    for (m.get(bag).?.items) |bc| {
        c += bc.n * traverse2(m, bc.bag);
    }
    return c;
}

fn part2(palloc: std.mem.Allocator, inp: anytype) !usize {
    var arena = std.heap.ArenaAllocator.init(palloc);
    defer arena.deinit();
    const alloc = arena.allocator();
    var map = std.StringHashMap(std.ArrayList(*BS)).init(alloc);
    for (inp) |line| {
        var lit = std.mem.split(u8, line, " bags contain ");
        const bag = lit.next().?;
        const spec = lit.next().?;
        if (spec[0] == 'n' and spec[1] == 'o' and spec[2] == ' ') {
            continue;
        }
        var sit = std.mem.split(u8, spec, ", ");
        while (sit.next()) |bags| {
            var bit = std.mem.split(u8, bags, " ");
            const ns = bit.next().?;
            const n = try std.fmt.parseUnsigned(usize, ns, 10);
            const b1 = bit.next().?;
            const b2 = bit.next().?;
            var innerBag = try alloc.alloc(u8, b1.len + b2.len + 1);
            std.mem.copy(u8, innerBag[0..], b1);
            innerBag[b1.len] = ' ';
            std.mem.copy(u8, innerBag[b1.len + 1 ..], b2);
            const kv = try map.getOrPutValue(bag, std.ArrayList(*BS).init(alloc));
            var bs = try alloc.create(BS);
            bs.bag = innerBag;
            bs.n = n;
            try kv.value_ptr.append(bs);
        }
    }
    return traverse2(map, "shiny gold") - 1;
}

fn day07(inp: []const u8, bench: bool) anyerror!void {
    var spec = aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(spec);
    var p1 = try part1(aoc.halloc, spec);
    var p2 = try part2(aoc.halloc, spec);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day07);
}
