usingnamespace @import("aoc-lib.zig");

const Game = struct {
    d1: []u8,
    d2: []u8,
    debug: bool,

    pub fn init(in: [][]const u8) *Game {
        var self = alloc.create(Game) catch unreachable;
        var l: usize = 0;
        var it = split(in[0], "\n");
        while (it.next()) |_| {
            l += 1;
        }
        l -= 1;
        self.d1 = alloc.alloc(u8, l) catch unreachable;
        it = split(in[0], "\n");
        _ = it.next();
        var i: usize = 0;
        while (it.next()) |line| {
            self.d1[i] = parseUnsigned(u8, line, 10) catch unreachable;
            i += 1;
        }
        l = 0;
        it = split(in[1], "\n");
        while (it.next()) |_| {
            l += 1;
        }
        l -= 1;
        self.d2 = alloc.alloc(u8, l) catch unreachable;
        it = split(in[1], "\n");
        _ = it.next();
        i = 0;
        while (it.next()) |line| {
            self.d2[i] = parseUnsigned(u8, line, 10) catch unreachable;
            i += 1;
        }
        self.debug = false;
        return self;
    }

    pub fn Score(d: []const u8) usize {
        var s: usize = 0;
        var i: usize = 1;
        while (i <= d.len) {
            s += (1 + d.len - i) * @as(usize, d[i - 1]);
            i += 1;
        }
        return s;
    }

    const Result = struct {
        player: usize,
        deck: []const u8,
    };

    pub fn copyd(all: anytype, d: []u8) []u8 {
        var result = all.alloc(u8, d.len) catch unreachable;
        copy(u8, result[0..], d);
        return result;
    }

    pub fn append(all: anytype, d: []u8, a: u8, b: u8) []u8 {
        var result = all.alloc(u8, d.len + 2) catch unreachable;
        copy(u8, result[0..], d);
        result[d.len] = a;
        result[d.len + 1] = b;
        all.free(d);
        return result;
    }

    pub fn tail(all: anytype, d: []u8) []u8 {
        var result = all.alloc(u8, d.len - 1) catch unreachable;
        copy(u8, result[0..], d[1..d.len]);
        all.free(d);
        return result;
    }

    pub fn subdeck(all: anytype, d: []u8, c: u8) []u8 {
        var result = all.alloc(u8, c) catch unreachable;
        copy(u8, result[0..], d[0..c]);
        return result;
    }

    pub fn key(all: anytype, d1: []u8, d2: []u8) []u8 {
        var result = all.alloc(u8, d1.len + 1 + d2.len) catch unreachable;
        copy(u8, result[0..], d1);
        result[d1.len] = 0;
        copy(u8, result[d1.len + 1 ..], d2);
        return result;
    }

    pub fn Combat(g: *Game, in: [2][]u8, part2: bool) Result {
        var round: usize = 1;
        var arenaAllocator = ArenaAllocator.init(alloc);
        defer arenaAllocator.deinit();
        var arena = &arenaAllocator.allocator;
        var d = [2][]u8{ copyd(arena, in[0]), copyd(arena, in[1]) };
        var seen = StringHashMap(bool).init(arena);
        defer seen.deinit();
        var first = true;
        while (d[0].len > 0 and d[1].len > 0) {
            if (g.debug) {
                warn("{}: d1={x} d2={x}\n", .{ round, d[0], d[1] });
            }
            const k = key(arena, d[0], d[1]);
            if (seen.contains(k)) {
                if (g.debug) {
                    warn("{}: p1! (seen)\n", .{round});
                }
                return Result{ .player = 0, .deck = d[0] };
            }
            seen.put(k, true) catch unreachable;
            const c: [2]u8 = [2]u8{ d[0][0], d[1][0] };
            d[0] = tail(arena, d[0]);
            d[1] = tail(arena, d[1]);
            if (g.debug) {
                warn("{}: c1={} c2={}\n", .{ round, c[0], c[1] });
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
                    warn("{}: subgame\n", .{round});
                }
                const subres = g.Combat(sd, part2);
                w = subres.player;
            } else {
                w = if (c[0] > c[1]) 0 else 1;
            }
            if (g.debug) {
                warn("{}: p{}!\n", .{ round, w + 1 });
            }
            d[w] = append(arena, d[w], c[w], c[1 - w]);
            round += 1;
        }
        if (d[0].len > 0) {
            if (g.debug) {
                warn("p1!\n", .{});
            }
            return Result{ .player = 0, .deck = copyd(alloc, d[0]) };
        } else {
            if (g.debug) {
                warn("p2!\n", .{});
            }
            return Result{ .player = 1, .deck = copyd(alloc, d[1]) };
        }
    }

    pub fn Part1(g: *Game) usize {
        var d = [_][]u8{ g.d1, g.d2 };
        var r = g.Combat(d, false);
        return Score(r.deck);
    }

    pub fn Part2(g: *Game) usize {
        var d = [_][]u8{ g.d1, g.d2 };
        var r = g.Combat(d, true);
        return Score(r.deck);
    }
};

test "seen" {
    const test1 = readChunks(test1file);
    const inp = readChunks(inputfile);

    var seen = StringHashMap(bool).init(alloc);
    defer seen.deinit();

    var g1 = Game.init(test1);
    var k1 = Game.key(g1.d1, g1.d2);
    var k2 = Game.key(g1.d2, g1.d1);
    assertEq(false, seen.contains(k1));
    assertEq(false, seen.contains(k2));
    try seen.put(k1, true);
    assertEq(true, seen.contains(k1));
    assertEq(false, seen.contains(k2));
    try seen.put(k2, true);
    assertEq(true, seen.contains(k1));
    assertEq(true, seen.contains(k2));

    var g = Game.init(inp);
    k1 = Game.key(g.d1, g.d2);
    k2 = Game.key(g.d2, g.d1);
    assertEq(false, seen.contains(k1));
    assertEq(false, seen.contains(k2));
    try seen.put(k1, true);
    assertEq(true, seen.contains(k1));
    assertEq(false, seen.contains(k2));
    try seen.put(k2, true);
    assertEq(true, seen.contains(k1));
    assertEq(true, seen.contains(k2));
}

test "examples" {
    const test1 = readChunks(test1file);
    const inp = readChunks(inputfile);

    var g1 = Game.init(test1);
    assertEq(@as(usize, 306), g1.Part1());
    assertEq(@as(usize, 291), g1.Part2());
    var g2 = Game.init(inp);
    assertEq(@as(usize, 32856), g2.Part1());
    assertEq(@as(usize, 33805), g2.Part2());
}

pub fn main() anyerror!void {
    const chunks = readChunks(input());
    var g = Game.init(chunks);
    //try print("Part1: {}\n", .{g.Part1()});
    try print("Part2: {}\n", .{g.Part2()});
}
