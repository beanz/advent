const std = @import("std");
const aoc = @import("aoc-lib.zig");

pub fn HexTile(q: i8, r: i8) usize {
    return @as(usize, @intCast(((@as(i32, @intCast(q)) + 127) << 8) + (@as(i32, @intCast(r)) + 127)));
}

pub fn Q(ht: usize) i8 {
    return @as(i8, @intCast(@as(i32, @intCast(ht >> 8)) - 127));
}
pub fn R(ht: usize) i8 {
    return @as(i8, @intCast(@as(i32, @intCast(ht & 0xff)) - 127));
}

pub fn HexTileNeighbours(ht: usize) [6]usize {
    const q = Q(ht);
    const r = R(ht);
    return [_]usize{
        HexTile(q + 1, r + 0),
        HexTile(q + 0, r - 1),
        HexTile(q - 1, r - 1),
        HexTile(q - 1, r + 0),
        HexTile(q + 0, r + 1),
        HexTile(q + 1, r + 1),
    };
}

pub fn HexTileFromString(m: []const u8) usize {
    var q: i8 = 0;
    var r: i8 = 0;
    var i: usize = 0;
    while (i < m.len) : (i += 1) {
        switch (m[i]) {
            'e' => {
                q += 1;
            },
            'w' => {
                q -= 1;
            },
            's' => {
                if (m[i + 1] == 'e') {
                    r -= 1;
                } else {
                    q -= 1;
                    r -= 1;
                }
                i += 1;
            },
            'n' => {
                if (m[i + 1] == 'e') {
                    q += 1;
                    r += 1;
                } else {
                    r += 1;
                }
                i += 1;
            },
            else => {
                unreachable;
            },
        }
    }
    return HexTile(q, r);
}

test "hex tile" {
    const ht = HexTileFromString("sesenwnenenewseeswwswswwnenewsewsw");
    try aoc.assertEq(@as(i8, -3), Q(ht));
    try aoc.assertEq(@as(i8, -2), R(ht));
    const n = HexTileNeighbours(ht);
    try aoc.assertEq(@as(i8, -2), Q(n[0]));
    try aoc.assertEq(@as(i8, -2), R(n[0]));

    try aoc.assertEq(@as(i8, -3), Q(n[1]));
    try aoc.assertEq(@as(i8, -3), R(n[1]));

    try aoc.assertEq(@as(i8, -4), Q(n[2]));
    try aoc.assertEq(@as(i8, -3), R(n[2]));

    try aoc.assertEq(@as(i8, -4), Q(n[3]));
    try aoc.assertEq(@as(i8, -2), R(n[3]));

    try aoc.assertEq(@as(i8, -3), Q(n[4]));
    try aoc.assertEq(@as(i8, -1), R(n[4]));

    try aoc.assertEq(@as(i8, -2), Q(n[5]));
    try aoc.assertEq(@as(i8, -1), R(n[5]));
}

const HexLife = struct {
    pub const State = enum(u2) { white, black };
    pub const BB = struct {
        qmin: i8,
        qmax: i8,
        rmin: i8,
        rmax: i8,
        alloc: std.mem.Allocator,
        pub fn init(alloc: std.mem.Allocator) !*BB {
            var s = try alloc.create(BB);
            s.alloc = alloc;
            s.qmin = std.math.maxInt(i8);
            s.qmax = std.math.minInt(i8);
            s.rmin = std.math.maxInt(i8);
            s.rmax = std.math.minInt(i8);
            return s;
        }
        pub fn deinit(s: *BB) void {
            s.alloc.destroy(s);
        }
        pub fn reset(s: *BB) void {
            s.qmin = std.math.maxInt(i8);
            s.qmax = std.math.minInt(i8);
            s.rmin = std.math.maxInt(i8);
            s.rmax = std.math.minInt(i8);
        }
        pub fn Update(s: *BB, q: i8, r: i8) void {
            if (q < s.qmin) {
                s.qmin = q;
            }
            if (q > s.qmax) {
                s.qmax = q;
            }
            if (r < s.rmin) {
                s.rmin = r;
            }
            if (r > s.rmax) {
                s.rmax = r;
            }
        }
    };
    init: std.AutoHashMap(usize, State),
    alloc: std.mem.Allocator,
    debug: bool,

    pub fn init(alloc: std.mem.Allocator, in: [][]const u8) !*HexLife {
        var s = try alloc.create(HexLife);
        s.alloc = alloc;
        s.debug = false;
        s.init = std.AutoHashMap(usize, State).init(alloc);
        for (in) |line| {
            const ht = HexTileFromString(line);
            if (s.init.contains(ht)) {
                _ = s.init.remove(ht);
            } else {
                try s.init.put(ht, .black);
            }
        }
        return s;
    }

    pub fn deinit(s: *HexLife) void {
        s.init.deinit();
        s.alloc.destroy(s);
    }

    pub fn part1(s: *HexLife) usize {
        return s.init.count();
    }

    pub fn part2(s: *HexLife, days: usize) usize {
        var cur = std.AutoHashMap(usize, State).init(s.alloc);
        defer cur.deinit();
        var cur_bb = BB.init(s.alloc) catch unreachable;
        defer cur_bb.deinit();
        var it = s.init.iterator();
        while (it.next()) |e| {
            const ht = e.key_ptr.*;
            cur.put(ht, .black) catch unreachable;
            cur_bb.Update(Q(ht), R(ht));
        }
        var next = std.AutoHashMap(usize, State).init(s.alloc);
        defer next.deinit();
        var day: usize = 1;
        var bc: usize = 0;
        var next_bb = BB.init(s.alloc) catch unreachable;
        defer next_bb.deinit();
        while (day <= days) : (day += 1) {
            bc = 0;
            var q = cur_bb.qmin - 1;
            while (q <= cur_bb.qmax + 1) : (q += 1) {
                var r = cur_bb.rmin - 1;
                while (r <= cur_bb.rmax + 1) : (r += 1) {
                    var nc: usize = 0;
                    const ht = HexTile(q, r);
                    for (HexTileNeighbours(ht)) |n| {
                        const nst = cur.get(n) orelse .white;
                        if (nst == .black) {
                            nc += 1;
                        }
                    }
                    const st = cur.get(ht) orelse .white;
                    if ((st == .black and !(nc == 0 or nc > 2)) or
                        (st == .white and nc == 2))
                    {
                        next.put(ht, .black) catch unreachable;
                        bc += 1;
                        next_bb.Update(Q(ht), R(ht));
                    }
                }
            }
            if (s.debug) {
                std.debug.print("Day {}: {} ({})\n", .{ day, bc, next.count() });
            }
            const tmp = cur;
            cur = next;
            next = tmp;
            next.clearAndFree();
            const tmp_bb = cur_bb;
            cur_bb = next_bb;
            next_bb = tmp_bb;
            next_bb.reset();
        }
        if (s.debug) {
            std.debug.print("N: {} - {}  {} - {}\n", .{
                cur_bb.qmin, cur_bb.qmax,
                cur_bb.rmin, cur_bb.rmax,
            });
        }
        return bc;
    }
};

test "hex life part1" {
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var gt = try HexLife.init(aoc.talloc, test1);
    defer gt.deinit();
    try aoc.assertEq(@as(usize, 10), gt.part1());
    var g = try HexLife.init(aoc.talloc, inp);
    defer g.deinit();
    try aoc.assertEq(@as(usize, 307), g.part1());
}

test "hex life part2" {
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var gt = try HexLife.init(aoc.talloc, test1);
    defer gt.deinit();
    var g = try HexLife.init(aoc.talloc, inp);
    defer g.deinit();

    try aoc.assertEq(@as(usize, 15), gt.part2(1));
    try aoc.assertEq(@as(usize, 12), gt.part2(2));
    try aoc.assertEq(@as(usize, 37), gt.part2(10));
    try aoc.assertEq(@as(usize, 2208), gt.part2(100));
    try aoc.assertEq(@as(usize, 3787), g.part2(100));
}

fn day24(inp: []const u8, bench: bool) anyerror!void {
    const lines = try aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var g = try HexLife.init(aoc.halloc, lines);
    defer g.deinit();
    const p1 = g.part1();
    const p2 = g.part2(100);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day24);
}
