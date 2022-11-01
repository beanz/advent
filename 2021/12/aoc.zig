const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Cave = struct {
    next: [16]u16,
    lower: u16,
    max: u16,
    alloc: std.mem.Allocator,

    const START = 1;
    const END = 2;

    pub fn init(alloc: std.mem.Allocator, inp: []const u8) !*Cave {
        var cave = try alloc.create(Cave);
        cave.alloc = alloc;
        std.mem.set(u16, cave.next[0..], 0);
        cave.lower = 0;
        cave.max = END;
        var ids = std.StringHashMap(u16).init(alloc);
        defer ids.deinit();
        try ids.put("start", START);
        try ids.put("end", END);
        var start: usize = 0;
        var dash: usize = 0;
        for (inp) |ch, i| {
            switch (ch) {
                '-' => {
                    dash = i;
                },
                '\n' => {
                    try cave.addpath(
                        &ids,
                        inp[start..dash],
                        inp[dash + 1 .. i],
                    );
                    start = i + 1;
                },
                else => {},
            }
        }
        //aoc.print("{any}\n", .{cave}) catch unreachable;
        return cave;
    }
    pub fn deinit(self: *Cave) void {
        self.alloc.destroy(self);
    }
    pub fn solve(self: *Cave, start: u16, cseen: u16, cache: *std.AutoHashMap(usize, usize), p2: bool, twice: bool) anyerror!usize {
        //aoc.print("solving {b} {b}\n", .{ start, cseen });
        var seen = cseen;
        if (start == END) {
            //aoc.print("  found end\n", .{});
            return 1;
        }
        if (self.lower & start != 0) {
            seen |= start;
        }
        var k = ((@as(usize, @ctz(start)) << 16) + seen) << 1;
        if (twice) {
            k += 1;
        }
        if (cache.get(k)) |v| {
            //aoc.print("  found in cache {}\n", .{v});
            return v;
        }
        var paths: usize = 0;
        var neighbors = self.next[@ctz(start)];
        //aoc.print("  neighbors: {b}\n", .{neighbors});
        var nb: u16 = 1;
        while (nb <= self.max) : (nb <<= 1) {
            if (nb & neighbors == 0) {
                continue;
            }
            var ntwice = twice;
            if (seen & nb != 0) {
                if (!p2 or twice) {
                    continue;
                }
                ntwice = true;
            }
            paths += try self.solve(nb, seen, cache, p2, ntwice);
        }
        try cache.put(k, paths);
        return paths;
    }
    pub fn part1(self: *Cave) !usize {
        var cache = std.AutoHashMap(usize, usize).init(self.alloc);
        defer cache.deinit();
        return try self.solve(START, 0, &cache, false, false);
    }
    pub fn part2(self: *Cave) !usize {
        var cache = std.AutoHashMap(usize, usize).init(self.alloc);
        defer cache.deinit();
        return try self.solve(START, 0, &cache, true, false);
    }
    fn id(self: *Cave, ids: *std.StringHashMap(u16), cave: []const u8) !u16 {
        if (ids.get(cave)) |v| {
            return v;
        }
        self.max <<= 1;
        try ids.put(cave, self.max);
        if ('a' <= cave[0] and cave[0] <= 'z') {
            self.lower |= self.max;
        }
        return self.max;
    }
    fn addpath(self: *Cave, ids: *std.StringHashMap(u16), s: []const u8, e: []const u8) !void {
        var start = try self.id(ids, s);
        var end = try self.id(ids, e);
        //aoc.print("would add path {s} {b} {} -> {s} {b} {}\n", .{
        //    s, start, @ctz(start), e, end, @ctz(end),
        //}) catch unreachable;
        if (end != START and start != END) { // don't add path to start
            self.next[@ctz(start)] |= end;
        }
        if (start != START and end != END) { // don't add path to start
            self.next[@ctz(end)] |= start;
        }
    }
};

test "part1" {
    var t1 = try Cave.init(aoc.talloc, aoc.test1file);
    defer t1.deinit();
    try aoc.assertEq(@as(usize, 10), try t1.part1());
    var t2 = try Cave.init(aoc.talloc, aoc.test2file);
    defer t2.deinit();
    try aoc.assertEq(@as(usize, 19), try t2.part1());
    var t3 = try Cave.init(aoc.talloc, aoc.test3file);
    defer t3.deinit();
    try aoc.assertEq(@as(usize, 226), try t3.part1());
    var r = try Cave.init(aoc.talloc, aoc.inputfile);
    defer r.deinit();
    try aoc.assertEq(@as(usize, 4691), try r.part1());
}

test "part2" {
    var t1 = try Cave.init(aoc.talloc, aoc.test1file);
    defer t1.deinit();
    try aoc.assertEq(@as(usize, 36), try t1.part2());
    var t2 = try Cave.init(aoc.talloc, aoc.test2file);
    defer t2.deinit();
    try aoc.assertEq(@as(usize, 103), try t2.part2());
    var t3 = try Cave.init(aoc.talloc, aoc.test3file);
    defer t3.deinit();
    try aoc.assertEq(@as(usize, 3509), try t3.part2());
    var r = try Cave.init(aoc.talloc, aoc.inputfile);
    defer r.deinit();
    try aoc.assertEq(@as(usize, 140718), try r.part2());
}

fn day12(inp: []const u8, bench: bool) anyerror!void {
    var cave = try Cave.init(aoc.halloc, inp);
    var p1 = try cave.part1();
    var p2 = try cave.part2();
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day12);
}
