const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Tile = struct {
    num: usize,
    lines: [][]u8,
    width: usize,
    top: u10,
    right: u10,
    bottom: u10,
    left: u10,
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator, chunk: []const u8) !*Tile {
        var s = try alloc.create(Tile);
        s.alloc = alloc;
        var lit = std.mem.split(u8, chunk, "\n");
        var first = lit.next().?;
        s.num = std.fmt.parseUnsigned(usize, first[5..9], 10) catch unreachable;
        var ls = std.ArrayList([]u8).init(alloc);
        defer ls.deinit();
        while (lit.next()) |line| {
            var x = try alloc.dupe(u8, line);
            try ls.append(x);
        }
        s.lines = ls.toOwnedSlice();
        s.width = s.lines.len;
        s.calc_edges();
        return s;
    }

    pub fn deinit(s: *Tile) void {
        for (s.lines) |_, i| {
            s.alloc.free(s.lines[i]);
        }
        s.alloc.free(s.lines);
        s.alloc.destroy(s);
    }

    pub fn flip(s: *Tile) void {
        aoc.reverseLines(s.lines);
        s.calc_edges();
    }

    pub fn rotate(s: *Tile) void {
        aoc.rotateLines(s.lines);
        s.calc_edges();
    }

    pub fn calc_edges(s: *Tile) void {
        const end = s.width - 1;
        s.top = 0;
        s.right = 0;
        s.bottom = 0;
        s.left = 0;
        var i: usize = 0;
        while (i < s.width) : (i += 1) {
            s.top <<= 1;
            s.left <<= 1;
            s.bottom <<= 1;
            s.right <<= 1;
            if (s.lines[0][i] == '#') {
                s.top += 1;
            }
            if (s.lines[end][i] == '#') {
                s.bottom += 1;
            }
            if (s.lines[i][end] == '#') {
                s.right += 1;
            }
            if (s.lines[i][0] == '#') {
                s.left += 1;
            }
        }
    }
};

test "tile" {
    var t = try Tile.init(aoc.talloc, "Tile 1951:\n.#.\n.##\n#.#");
    defer t.deinit();
    try aoc.assertEq(@as(usize, 1951), t.num);
    try aoc.assertEq(@as(u10, 2), t.top);
    try aoc.assertEq(@as(u10, 3), t.right);
    try aoc.assertEq(@as(u10, 5), t.bottom);
    try aoc.assertEq(@as(u10, 1), t.left);
    t.flip();
    try aoc.assertEq(@as(u10, 5), t.top);
    try aoc.assertEq(@as(u10, 6), t.right);
    try aoc.assertEq(@as(u10, 2), t.bottom);
    try aoc.assertEq(@as(u10, 4), t.left);
    t.flip();
    try aoc.assertEq(@as(u10, 2), t.top);
    try aoc.assertEq(@as(u10, 3), t.right);
    try aoc.assertEq(@as(u10, 5), t.bottom);
    try aoc.assertEq(@as(u10, 1), t.left);
    t.rotate();
    try aoc.assertEq(@as(u10, 4), t.top);
    try aoc.assertEq(@as(u10, 2), t.right);
    try aoc.assertEq(@as(u10, 6), t.bottom);
    try aoc.assertEq(@as(u10, 5), t.left);
    t.rotate();
    try aoc.assertEq(@as(u10, 5), t.top);
    try aoc.assertEq(@as(u10, 4), t.right);
    try aoc.assertEq(@as(u10, 2), t.bottom);
    try aoc.assertEq(@as(u10, 6), t.left);
}

fn CanonicalEdge(e: u10) u10 {
    const r = @bitReverse(e);
    if (e < r) {
        return e;
    } else {
        return r;
    }
}

test "canonical" {
    try aoc.assertEq(@as(u10, 210), CanonicalEdge(@as(u10, 300)));
    try aoc.assertEq(@as(u10, 791), CanonicalEdge(@as(u10, 931)));
}

const Water = struct {
    tiles: std.AutoHashMap(usize, *Tile),
    edges: std.AutoHashMap(usize, std.ArrayList(usize)),
    starter: usize,
    width: usize,
    alloc: std.mem.Allocator,
    debug: bool,

    pub fn init(alloc: std.mem.Allocator, in: [][]const u8) !*Water {
        var s = try alloc.create(Water);
        s.alloc = alloc;
        s.debug = false;
        s.tiles = std.AutoHashMap(usize, *Tile).init(alloc);
        s.edges = std.AutoHashMap(usize, std.ArrayList(usize)).init(alloc);
        s.starter = 0;
        for (in) |chunk| {
            var tile = try Tile.init(alloc, chunk);
            try s.tiles.put(tile.num, tile);
            for ([_]u10{ tile.top, tile.right, tile.bottom, tile.left }) |e| {
                const ce = CanonicalEdge(e);
                var kv = try s.edges.getOrPutValue(ce, std.ArrayList(usize).init(alloc));
                try kv.value_ptr.append(tile.num);
            }
        }
        s.width = isqrt(s.tiles.count());
        if (s.debug) {
            std.debug.print("width {}\n", .{s.width});
        }

        return s;
    }

    pub fn deinit(s: *Water) void {
        var it = s.tiles.iterator();
        while (it.next()) |e| {
            e.value_ptr.*.deinit();
        }
        s.tiles.deinit();
        var eit = s.edges.iterator();
        while (eit.next()) |e| {
            e.value_ptr.*.deinit();
        }
        s.edges.deinit();
        s.alloc.destroy(s);
    }

    pub fn EdgeTileCount(s: *Water, e: u10) usize {
        const ce = CanonicalEdge(e);
        return (s.edges.get(ce) orelse unreachable).items.len;
    }

    pub fn Part1(s: *Water) usize {
        var p: usize = 1;
        var it = s.tiles.iterator();
        while (it.next()) |kv| {
            var tile = kv.value_ptr.*;
            var c: usize = 0;
            for ([_]u10{ tile.top, tile.right, tile.bottom, tile.left }) |e| {
                if (s.EdgeTileCount(e) > 1) {
                    c += 1;
                }
            }
            if (c == 2) {
                if (s.debug) {
                    std.debug.print("Found corner {}\n", .{tile.num});
                }
                p *= tile.num;
                s.starter = tile.num; // starter corner for part 2
            }
        }
        return p;
    }

    pub fn EdgeTiles(s: *Water, e: u10) []usize {
        const ce = CanonicalEdge(e);
        return (s.edges.get(ce) orelse unreachable).items;
    }

    pub fn FindRightTile(s: *Water, n: usize) usize {
        var t = s.tiles.get(n) orelse unreachable;
        var edge = t.right;
        var matching = s.EdgeTiles(edge);
        var match: usize = 0;
        for (matching) |tn| {
            if (tn != t.num) {
                match = tn;
                break;
            }
        }
        if (match == 0) {
            if (s.debug) {
                std.debug.print("no match found\n", .{});
            }
            return 0;
        }
        if (s.debug) {
            std.debug.print("  found next tile {}\n", .{match});
        }
        var next = s.tiles.get(match) orelse unreachable;
        var i: u8 = 0;
        while (i < 8) : (i += 1) {
            if (next.left == edge) {
                return next.num;
            }
            if (i == 3) {
                next.flip();
            } else {
                next.rotate();
            }
        }
        std.debug.print("Failed to find next tile orientation\n", .{});
        return 0;
    }

    pub fn FindBottomTile(s: *Water, n: usize) usize {
        var t = s.tiles.get(n) orelse unreachable;
        var edge = t.bottom;
        var matching = s.EdgeTiles(edge);
        var match: usize = 0;
        for (matching) |tn| {
            if (tn != t.num) {
                match = tn;
                break;
            }
        }
        if (match == 0) {
            if (s.debug) {
                std.debug.print("no match found\n", .{});
            }
            return 0;
        }
        if (s.debug) {
            std.debug.print("  found next tile {}\n", .{match});
        }
        var next = s.tiles.get(match) orelse unreachable;
        var i: u8 = 0;
        while (i < 8) : (i += 1) {
            if (next.top == edge) {
                return next.num;
            }
            if (i == 3) {
                next.flip();
            } else {
                next.rotate();
            }
        }
        std.debug.print("  Failed to find next tile orientation\n", .{});
        return 0;
    }

    fn isqrt(x: usize) usize {
        const ix = @intCast(isize, x);
        var q: isize = 1;
        while (q <= ix) {
            q <<= 2;
        }
        var z = ix;
        var r: isize = 0;
        while (q > 1) {
            q >>= 2;
            var t = z - r - q;
            r >>= 1;
            if (t >= 0) {
                z = t;
                r += q;
            }
        }
        return @intCast(usize, r);
    }

    pub fn Image(s: *Water) [][]const u8 {
        var layout = s.alloc.alloc(usize, s.tiles.count()) catch unreachable;
        defer s.alloc.free(layout);
        if (s.starter == 0) {
            _ = s.Part1();
        }
        if (s.debug) {
            std.debug.print("Starting with corner {}\n", .{s.starter});
        }
        var t = s.tiles.get(s.starter) orelse unreachable;
        while (s.EdgeTileCount(t.right) != 2 or s.EdgeTileCount(t.bottom) != 2) {
            t.rotate();
        }
        layout[0] = t.num;
        var i: usize = 1;
        while (i < s.width * s.width) : (i += 1) {
            var tn: usize = undefined;
            if ((i % s.width) == 0) {
                tn = s.FindBottomTile(layout[i - s.width]);
            } else {
                tn = s.FindRightTile(layout[i - 1]);
            }
            if (tn == 0) {
                std.debug.print("failed to find next tile\n", .{});
                unreachable;
            }
            if (s.debug) {
                std.debug.print("Found #{}: {}\n", .{ i, tn });
            }
            layout[i] = tn;
        }
        var tl = t.width - 2;
        var nl = s.width * tl;
        var res = s.alloc.alloc([]u8, nl) catch unreachable;
        var irow: usize = 0;
        while (irow < s.width) : (irow += 1) {
            var trow: usize = 0;
            while (trow < t.width - 2) : (trow += 1) {
                res[irow * tl + trow] = s.alloc.alloc(u8, nl) catch unreachable;
                var icol: usize = 0;
                while (icol < s.width) : (icol += 1) {
                    var tt = s.tiles.get(layout[irow * s.width + icol]) orelse unreachable;
                    var tcol: usize = 0;
                    while (tcol < t.width - 2) : (tcol += 1) {
                        res[irow * tl + trow][icol * tl + tcol] = tt.lines[trow + 1][tcol + 1];
                    }
                }
            }
        }
        return res;
    }

    pub fn Part2(s: *Water) usize {
        var image = s.Image();
        defer {
            for (image) |_, j| {
                s.alloc.free(image[j]);
            }
            s.alloc.free(image);
        }
        if (s.debug) {
            for (image) |l| {
                std.debug.print("{s}\n", .{l});
            }
            std.debug.print("\n", .{});
        }
        const monster = aoc.readLines(s.alloc, @embedFile("monster.txt"));
        defer s.alloc.free(monster);
        const mh = monster.len;
        const mw = monster[0].len;
        var monsterSize: usize = aoc.countCharsInLines(monster, '#');
        const ih = image.len;
        const iw = image[0].len;
        if (s.debug) {
            std.debug.print("image {} x {}\n", .{ iw, ih });
            std.debug.print("monster {} x {} #={}\n", .{ mw, mh, monsterSize });
        }
        var i: usize = 0;
        var mchars: usize = 0;
        while (i < 8) : (i += 1) {
            var r: usize = 0;
            while (r < (ih - mh)) : (r += 1) {
                var c: usize = 0;
                while (c < (iw - mw)) : (c += 1) {
                    var match: bool = true;
                    var mr: usize = 0;
                    while (mr < mh and match) : (mr += 1) {
                        var mc: usize = 0;
                        while (mc < mw and match) : (mc += 1) {
                            if (monster[mr][mc] != '#') {
                                continue;
                            }
                            if (image[r + mr][c + mc] != '#') {
                                match = false;
                            }
                        }
                    }
                    if (match) {
                        if (s.debug) {
                            std.debug.print("found monster at {},{}\n", .{ c, r });
                        }
                        mchars += monsterSize;
                    }
                }
            }
            if (i == 3) {
                aoc.reverseLines(image);
            } else {
                var old = image;
                defer {
                    for (old) |_, j| {
                        s.alloc.free(old[j]);
                    }
                    s.alloc.free(old);
                }
                image = aoc.rotateLinesNonSymmetric(s.alloc, image);
            }
        }
        var c: usize = aoc.countCharsInLines(image, '#');
        return c - mchars;
    }
};

test "part1" {
    const test1 = aoc.readChunks(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = aoc.readChunks(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var wt = try Water.init(aoc.talloc, test1);
    defer wt.deinit();
    try aoc.assertEq(@as(usize, 20899048083289), wt.Part1());

    var w = try Water.init(aoc.talloc, inp);
    defer w.deinit();
    try aoc.assertEq(@as(usize, 17712468069479), w.Part1());
}

test "part2" {
    const test1 = aoc.readChunks(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = aoc.readChunks(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);
    var wt = try Water.init(aoc.talloc, test1);
    defer wt.deinit();
    try aoc.assertEq(@as(usize, 273), wt.Part2());

    var w = try Water.init(aoc.talloc, inp);
    defer w.deinit();
    try aoc.assertEq(@as(usize, 2173), w.Part2());
}

fn day20(inp: []const u8, bench: bool) anyerror!void {
    const chunks = aoc.readChunks(aoc.halloc, inp);
    defer aoc.halloc.free(chunks);
    var w = try Water.init(aoc.halloc, chunks);
    defer w.deinit();
    var p1 = w.Part1();
    var p2 = w.Part2();
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day20);
}
