const std = @import("std");
const aoc = @import("aoc-lib.zig");

const fmtSliceHexLower = std.fmt.fmtSliceHexLower;

const Game = struct {
    d1: []u8,
    d2: []u8,
    alloc: std.mem.Allocator,
    debug: bool,

    pub fn init(alloc: std.mem.Allocator, in: [][]const u8) !*Game {
        var self = try alloc.create(Game);
        var l: usize = 0;
        var it = std.mem.split(u8, in[0], "\n");
        while (it.next()) |_| {
            l += 1;
        }
        l -= 1;
        self.d1 = try alloc.alloc(u8, l);
        it = std.mem.split(u8, in[0], "\n");
        _ = it.next();
        var i: usize = 0;
        while (it.next()) |line| {
            self.d1[i] = try std.fmt.parseUnsigned(u8, line, 10);
            i += 1;
        }
        l = 0;
        it = std.mem.split(u8, in[1], "\n");
        while (it.next()) |_| {
            l += 1;
        }
        l -= 1;
        self.d2 = try alloc.alloc(u8, l);
        it = std.mem.split(u8, in[1], "\n");
        _ = it.next();
        i = 0;
        while (it.next()) |line| {
            self.d2[i] = try std.fmt.parseUnsigned(u8, line, 10);
            i += 1;
        }
        self.alloc = alloc;
        self.debug = false;
        return self;
    }

    pub fn deinit(self: *Game) void {
        self.alloc.free(self.d1);
        self.alloc.free(self.d2);
        self.alloc.destroy(self);
    }

    pub fn Score(d: []const u8) usize {
        var s: usize = 0;
        var i: usize = 1;
        while (i <= d.len) : (i += 1) {
            s += (1 + d.len - i) * @as(usize, d[i - 1]);
        }
        return s;
    }

    const Result = struct {
        player: usize,
        deck: []const u8,
    };

    pub fn copyd(all: anytype, d: []u8) []u8 {
        var result = all.alloc(u8, d.len) catch unreachable;
        std.mem.copy(u8, result[0..], d);
        return result;
    }

    pub fn append(all: anytype, d: []u8, a: u8, b: u8) []u8 {
        var result = all.alloc(u8, d.len + 2) catch unreachable;
        std.mem.copy(u8, result[0..], d);
        result[d.len] = a;
        result[d.len + 1] = b;
        all.free(d);
        return result;
    }

    pub fn tail(all: anytype, d: []u8) []u8 {
        var result = all.alloc(u8, d.len - 1) catch unreachable;
        std.mem.copy(u8, result[0..], d[1..d.len]);
        all.free(d);
        return result;
    }

    pub fn subdeck(all: anytype, d: []u8, c: u8) []u8 {
        var result = all.alloc(u8, c) catch unreachable;
        std.mem.copy(u8, result[0..], d[0..c]);
        return result;
    }

    pub fn key(d1: []u8, d2: []u8) usize {
        return Score(d1) * (31 + Score(d2));
    }

    pub fn Combat(g: *Game, in: [2][]u8, part2: bool) Result {
        var round: usize = 1;
        var arenaAllocator = std.heap.ArenaAllocator.init(g.alloc);
        defer arenaAllocator.deinit();
        var arena = arenaAllocator.allocator();
        var d = [2][]u8{ copyd(arena, in[0]), copyd(arena, in[1]) };
        var seen = std.AutoHashMap(usize, bool).init(arena);
        defer seen.deinit();
        while (d[0].len > 0 and d[1].len > 0) {
            if (g.debug) {
                std.debug.print("{}: d1={x} d2={x}\n", .{ round, fmtSliceHexLower(d[0]), fmtSliceHexLower(d[1]) });
            }
            const k = key(d[0], d[1]);
            if (seen.contains(k)) {
                if (g.debug) {
                    std.debug.print("{}: p1! (seen)\n", .{round});
                }
                return Result{ .player = 0, .deck = copyd(g.alloc, d[0]) };
            }
            seen.put(k, true) catch unreachable;
            const c: [2]u8 = [2]u8{ d[0][0], d[1][0] };
            d[0] = tail(arena, d[0]);
            d[1] = tail(arena, d[1]);
            if (g.debug) {
                std.debug.print("{}: c1={} c2={}\n", .{ round, c[0], c[1] });
            }
            var w: usize = 0;
            if (part2 and d[0].len >= c[0] and d[1].len >= c[1]) {
                const sd = [2][]u8{
                    subdeck(arena, d[0], c[0]),
                    subdeck(arena, d[1], c[1]),
                };
                defer arena.free(sd[0]);
                defer arena.free(sd[1]);
                if (g.debug) {
                    std.debug.print("{}: subgame\n", .{round});
                }
                const subres = g.Combat(sd, part2);
                w = subres.player;
                g.alloc.free(subres.deck);
            } else {
                w = if (c[0] > c[1]) 0 else 1;
            }
            if (g.debug) {
                std.debug.print("{}: p{}!\n", .{ round, w + 1 });
            }
            d[w] = append(arena, d[w], c[w], c[1 - w]);
            round += 1;
        }
        if (d[0].len > 0) {
            if (g.debug) {
                std.debug.print("p1!\n", .{});
            }
            return Result{ .player = 0, .deck = copyd(g.alloc, d[0]) };
        } else {
            if (g.debug) {
                std.debug.print("p2!\n", .{});
            }
            return Result{ .player = 1, .deck = copyd(g.alloc, d[1]) };
        }
    }

    pub fn Part1(g: *Game) usize {
        var d = [_][]u8{ g.d1, g.d2 };
        var r = g.Combat(d, false);
        defer g.alloc.free(r.deck);
        return Score(r.deck);
    }

    pub fn Part2(g: *Game) usize {
        var d = [_][]u8{ g.d1, g.d2 };
        var r = g.Combat(d, true);
        defer g.alloc.free(r.deck);
        return Score(r.deck);
    }
};

test "seen" {
    const test1 = try aoc.readChunks(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readChunks(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var seen = std.AutoHashMap(usize, bool).init(aoc.talloc);
    defer seen.deinit();

    var g1 = try Game.init(aoc.talloc, test1);
    defer g1.deinit();
    var k1 = Game.key(g1.d1, g1.d2);
    var k2 = Game.key(g1.d2, g1.d1);
    try aoc.assertEq(false, seen.contains(k1));
    try aoc.assertEq(false, seen.contains(k2));
    try seen.put(k1, true);
    try aoc.assertEq(true, seen.contains(k1));
    try aoc.assertEq(false, seen.contains(k2));
    try seen.put(k2, true);
    try aoc.assertEq(true, seen.contains(k1));
    try aoc.assertEq(true, seen.contains(k2));

    var g = try Game.init(aoc.talloc, inp);
    defer g.deinit();
    k1 = Game.key(g.d1, g.d2);
    k2 = Game.key(g.d2, g.d1);
    try aoc.assertEq(false, seen.contains(k1));
    try aoc.assertEq(false, seen.contains(k2));
    try seen.put(k1, true);
    try aoc.assertEq(true, seen.contains(k1));
    try aoc.assertEq(false, seen.contains(k2));
    try seen.put(k2, true);
    try aoc.assertEq(true, seen.contains(k1));
    try aoc.assertEq(true, seen.contains(k2));
}

test "examples" {
    const test1 = try aoc.readChunks(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readChunks(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var g1 = try Game.init(aoc.talloc, test1);
    defer g1.deinit();
    try aoc.assertEq(@as(usize, 306), g1.Part1());
    try aoc.assertEq(@as(usize, 291), g1.Part2());
    var g2 = try Game.init(aoc.talloc, inp);
    defer g2.deinit();
    try aoc.assertEq(@as(usize, 32856), g2.Part1());
    try aoc.assertEq(@as(usize, 33805), g2.Part2());
}

fn day22(inp: []const u8, bench: bool) anyerror!void {
    const chunks = try aoc.readChunks(aoc.halloc, inp);
    defer aoc.halloc.free(chunks);
    var g = try Game.init(aoc.halloc, chunks);
    defer g.deinit();
    var p1 = g.Part1();
    var p2 = g.Part2();
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day22);
}
