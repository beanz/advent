const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Map = struct {
    const MAX: usize = 22;
    const OFF: i8 = MAX / 2;

    cur: [MAX * MAX * MAX * MAX]bool,
    new: [MAX * MAX * MAX * MAX]bool,
    w: i8,
    w2: i8,
    alloc: std.mem.Allocator,
    debug: bool,

    const NB = [_]i8{ -1, 0, 1 };

    pub fn index(x: i8, y: i8, z: i8, q: i8) usize {
        return @as(usize, @intCast(x)) + MAX * (@as(usize, @intCast(y)) + MAX * (@as(usize, @intCast(z)) + MAX * @as(usize, @intCast(q))));
    }

    pub fn fromInput(alloc: std.mem.Allocator, inp: [][]const u8) !*Map {
        var m = try alloc.create(Map);
        m.alloc = alloc;
        @memset(m.cur[0..], false);
        @memset(m.new[0..], false);
        const size: i8 = @intCast(inp.len);
        m.w = size;
        const s2: i8 = size >> 1;
        m.w2 = s2;
        var y: i8 = 0;
        while (y < inp.len) : (y += 1) {
            var x: i8 = 0;
            while (x < inp[@intCast(y)].len) : (x += 1) {
                if (inp[@intCast(y)][@intCast(x)] == '#') {
                    m.Set(OFF - s2 + x, OFF - s2 + y, OFF, OFF);
                }
            }
        }
        m.Swap();
        return m;
    }

    pub fn deinit(self: *Map) void {
        self.alloc.destroy(self);
    }
    pub fn Print(self: *Map, iter: i8, part2: bool) void {
        const xystart: i8 = OFF - (1 + self.w2 + iter);
        const xyend: i8 = OFF + (2 + self.w2 + iter);
        const zstart: i8 = OFF - (1 + iter);
        const zend: i8 = OFF + (1 + iter);
        var qstart: i8 = OFF;
        var qend: i8 = OFF;
        if (part2) {
            qstart = zstart;
            qend = zend;
        }
        var q: i8 = qstart;
        while (q <= qend) : (q += 1) {
            var z: i8 = zstart;
            while (z <= zend) : (z += 1) {
                var y: i8 = xystart;
                std.debug.print("q={!} z={!}\n", .{ q, z });
                while (y <= xyend) : (y += 1) {
                    var x: i8 = xystart;
                    while (x <= xyend) : (x += 1) {
                        const cur = self.Get(x, y, z, q);
                        if (cur) {
                            std.debug.print("#", .{});
                            self.Set(x, y, z, q);
                        } else {
                            std.debug.print(".", .{});
                        }
                    }
                    std.debug.print(" ({!} {!})\n", .{ y, index(11, y, z, q) });
                }
            }
            std.debug.print("\n", .{});
        }
    }

    pub fn Set(self: *Map, x: i8, y: i8, z: i8, q: i8) void {
        self.new[index(x, y, z, q)] = true;
    }

    pub fn Get(self: *Map, x: i8, y: i8, z: i8, q: i8) bool {
        return self.cur[index(x, y, z, q)];
    }

    pub fn Swap(self: *Map) void {
        const tmp = self.cur;
        self.cur = self.new;
        self.new = tmp;
    }

    pub fn NeighbourCount(self: *Map, x: i8, y: i8, z: i8, q: i8, part2: bool) usize {
        var n: usize = 0;
        var qfirst: usize = 0;
        var qlast: usize = 3;
        if (!part2) {
            qfirst = 1;
            qlast = 2;
        }
        for (NB[qfirst..qlast]) |oq| {
            for (NB[0..3]) |oz| {
                for (NB[0..3]) |oy| {
                    for (NB[0..3]) |ox| {
                        if (ox == 0 and oy == 0 and oz == 0 and oq == 0) {
                            continue;
                        }
                        if (self.Get(x + ox, y + oy, z + oz, q + oq)) {
                            n += 1;
                        }
                    }
                }
            }
        }
        return n;
    }

    pub fn Iter(self: *Map, iter: i8, part2: bool) usize {
        var n: usize = 0;
        @memset(self.new[0..], false);

        const xystart: i8 = OFF - (1 + self.w2 + iter);
        const xyend: i8 = OFF + (2 + self.w2 + iter);
        const zstart: i8 = OFF - (1 + iter);
        const zend: i8 = OFF + (1 + iter);
        var qstart: i8 = OFF;
        var qend: i8 = OFF;
        if (part2) {
            qstart = zstart;
            qend = zend;
        }
        var q: i8 = qstart;
        while (q <= qend) : (q += 1) {
            var z: i8 = zstart;
            while (z <= zend) : (z += 1) {
                var y: i8 = xystart;
                while (y <= xyend) : (y += 1) {
                    var x: i8 = xystart;
                    while (x <= xyend) : (x += 1) {
                        const nc = self.NeighbourCount(x, y, z, q, part2);
                        const cur = self.Get(x, y, z, q);
                        var new = false;
                        if ((cur and nc == 2) or nc == 3) {
                            new = true;
                        }
                        if (new) {
                            self.Set(x, y, z, q);
                            n += 1;
                        }
                    }
                }
            }
        }

        self.Swap();
        //self.Print(iter, part2);
        return n;
    }

    pub fn Calc(self: *Map, part2: bool) usize {
        var r: usize = 0;
        var i: i8 = 0;
        while (i < 6) : (i += 1) {
            r = self.Iter(i, part2);
            if (self.debug) {
                std.debug.print("Iter {!}: {}\n", .{ i, r });
            }
        }
        return r;
    }

    pub fn Part1(self: *Map) !usize {
        return self.Calc(false);
    }

    pub fn Part2(self: *Map) !usize {
        return self.Calc(true);
    }
};

test "part1" {
    const test0 = try aoc.readLines(aoc.talloc, aoc.test0file);
    defer aoc.talloc.free(test0);
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var t1m = Map.fromInput(aoc.talloc, test1) catch unreachable;
    try aoc.assertEq(@as(usize, 112), try t1m.Part1());
    t1m.deinit();

    t1m = Map.fromInput(aoc.talloc, test1) catch unreachable;
    defer t1m.deinit();
    try aoc.assertEq(@as(usize, 848), try t1m.Part2());

    var m = Map.fromInput(aoc.talloc, inp) catch unreachable;
    try aoc.assertEq(@as(usize, 209), try m.Part1());
    m.deinit();

    m = Map.fromInput(aoc.talloc, inp) catch unreachable;
    defer m.deinit();
    try aoc.assertEq(@as(usize, 1492), try m.Part2());
}

fn day17(inp: []const u8, bench: bool) anyerror!void {
    const lines = try aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var m = try Map.fromInput(aoc.halloc, lines);
    const p1 = m.Part1();
    m.deinit();
    m = try Map.fromInput(aoc.halloc, lines);
    defer m.deinit();
    const p2 = m.Part2();
    if (!bench) {
        aoc.print("Part 1: {!}\nPart 2: {!}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day17);
}
